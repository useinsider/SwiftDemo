#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") -s <scheme> [options]

Required:
  -s, --scheme     Xcode scheme (e.g. ExamplePods, ExampleSPM, ExampleCarthage)
  -t, --team-id    Apple Developer Team ID

Optional:
  -o, --output     Output directory for the IPA (default: ./build/<scheme>)
  -m, --method     Export method: release-testing, app-store-connect, enterprise, development (default: release-testing)
  -v, --verbose    Print detailed build information
  --api-key-path       Path to App Store Connect API key (.p8)
  --api-key-id         App Store Connect API Key ID
  --api-key-issuer-id  App Store Connect Issuer ID

Examples:
  $(basename "$0") -s ExamplePods -t ABCDE12345
  $(basename "$0") --scheme ExampleSPM --team-id ABCDE12345 --output ~/Desktop/ipa
  $(basename "$0") --scheme ExampleCarthage --team-id ABCDE12345 --method app-store-connect
EOF
}

log() {
  if [[ "${VERBOSE}" == "true" ]]; then
    echo "$@"
  fi
}

SCHEME=""
TEAM_ID=""
EXPORT_METHOD="release-testing"
OUTPUT_DIR=""
VERBOSE="false"
API_KEY_PATH=""
API_KEY_ID=""
API_KEY_ISSUER_ID=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--scheme) SCHEME="$2"; shift 2;;
    -t|--team-id) TEAM_ID="$2"; shift 2;;
    -o|--output) OUTPUT_DIR="$2"; shift 2;;
    -m|--method) EXPORT_METHOD="$2"; shift 2;;
    -v|--verbose) VERBOSE="true"; shift;;
    --api-key-path) API_KEY_PATH="$2"; shift 2;;
    --api-key-id) API_KEY_ID="$2"; shift 2;;
    --api-key-issuer-id) API_KEY_ISSUER_ID="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) echo "Error: Unknown argument: $1"; usage; exit 1;;
  esac
done

if [[ -z "${SCHEME}" || -z "${TEAM_ID}" ]]; then
  echo "Error: --scheme and --team-id are required."
  usage
  exit 1
fi

case "${EXPORT_METHOD}" in
  release-testing|app-store-connect|enterprise|development);;
  *) echo "Error: Invalid export method: ${EXPORT_METHOD}"; usage; exit 1;;
esac

REPOSITORY_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
WORKSPACE="${REPOSITORY_DIR}/Example.xcworkspace"
BUILD_DIR="${REPOSITORY_DIR}/build/${SCHEME}"
ARCHIVE_PATH="${BUILD_DIR}/${SCHEME}.xcarchive"

if [[ -z "${OUTPUT_DIR}" ]]; then
  OUTPUT_DIR="${BUILD_DIR}"
fi

AUTH_ARGS=()
if [[ -n "${API_KEY_PATH}" && -n "${API_KEY_ID}" && -n "${API_KEY_ISSUER_ID}" ]]; then
  AUTH_ARGS+=(-authenticationKeyPath "${API_KEY_PATH}")
  AUTH_ARGS+=(-authenticationKeyID "${API_KEY_ID}")
  AUTH_ARGS+=(-authenticationKeyIssuerID "${API_KEY_ISSUER_ID}")
  log "Using App Store Connect API key for authentication"
fi

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

log "Workspace: ${WORKSPACE}"
log "Scheme: ${SCHEME}"
log "Export Method: ${EXPORT_METHOD}"
log "Output: ${OUTPUT_DIR}"

log "Cleaning: ${SCHEME}"
xcodebuild clean -workspace "${WORKSPACE}" -scheme "${SCHEME}"
log "Cleaned: ${SCHEME}"

log "Archiving: ${ARCHIVE_PATH}"
xcodebuild archive \
  -workspace "${WORKSPACE}" \
  -scheme "${SCHEME}" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "${ARCHIVE_PATH}" \
  -allowProvisioningUpdates \
  ${AUTH_ARGS[@]+"${AUTH_ARGS[@]}"}

if [[ ! -d "${ARCHIVE_PATH}" ]]; then
  echo "Error: Archive failed. ${ARCHIVE_PATH} not found."
  exit 1
fi
log "Archived: ${ARCHIVE_PATH}"

EXPORT_OPTIONS_PLIST="${BUILD_DIR}/ExportOptions.plist"
cat > "${EXPORT_OPTIONS_PLIST}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>${EXPORT_METHOD}</string>
    <key>teamID</key>
    <string>${TEAM_ID}</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>compileBitcode</key>
    <false/>
</dict>
</plist>
EOF

IPA_FILE="${OUTPUT_DIR}/${SCHEME}.ipa"
rm -rf "${IPA_FILE}"

log "Exporting: ${IPA_FILE}"
xcodebuild -exportArchive \
  -archivePath "${ARCHIVE_PATH}" \
  -exportPath "${OUTPUT_DIR}" \
  -exportOptionsPlist "${EXPORT_OPTIONS_PLIST}" \
  -allowProvisioningUpdates \
  ${AUTH_ARGS[@]+"${AUTH_ARGS[@]}"}

if [[ ! -f "${IPA_FILE}" ]]; then
  echo "Error: IPA export failed. ${IPA_FILE} not found."
  exit 1
fi
echo "Exported: ${IPA_FILE}"