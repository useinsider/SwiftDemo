/**
 * A callback function that will be invoked whenever the Insider ID changes.
 *
 * @param insiderID - The updated Insider ID string, or `null` if the ID is not available.
 */
type InsiderIDListener = (insiderID: string | null) => void;
/**
 * Represents a listener registration that allows the caller
 * to unsubscribe from updates.
 */
interface InsiderListenerRegistration {
    /**
     * Removes the registered listener from the notification list.
     */
    remove: () => void;
}

/**
 * Represents the position of the close button in the internal browser.
 */
declare enum CloseButtonPosition {
    /**
     * Close button positioned on the left side.
     */
    LEFT = "LEFT",
    /**
     * Close button positioned on the right side.
     */
    RIGHT = "RIGHT",
    /**
     * No close button displayed.
     */
    NONE = "NONE"
}

/**
 * Represents an analytics event that can be tracked with various parameter types.
 * This class provides a fluent interface for building events with typed parameters
 * before sending them to the native bridge for tracking.
 *
 * @example
 * ```typescript
 * const event = new InsiderEvent('user_purchase')
 *   .addStringParameter('product_id', 'abc123')
 *   .addNumericParameter('price', 29.99)
 *   .addBooleanParameter('is_premium', true);
 *
 * await event.build();
 * ```
 */
declare class InsiderEvent {
    readonly name: string;
    /**
     * Creates a new InsiderEvent instance.
     *
     * @param name - The name of the event to track
     */
    constructor(name: string);
    /**
     * Adds a string parameter to the event.
     *
     * @param key - Parameter key. Must not be empty, must start with a letter,
     *              and can only contain lowercase letters, numbers, and underscores.
     * @param value - The string value to associate with the key
     * @returns This InsiderEvent instance for method chaining
     *
     * @example
     * ```typescript
     * event.addStringParameter('user_id', 'user123')
     *      .addStringParameter('category', 'electronics');
     * ```
     */
    addStringParameter(key: string, value: string): this;
    /**
     * Adds a numeric parameter to the event.
     * Automatically distinguishes between integer and double based on the value.
     *
     * @param key - Parameter key. Must not be empty, must start with a letter,
     *              and can only contain lowercase letters, numbers, and underscores.
     * @param value - The numeric value to associate with the key
     * @returns This InsiderEvent instance for method chaining
     *
     * @example
     * ```typescript
     * event.addNumericParameter('price', 29.99)         // stored as double
     *      .addNumericParameter('quantity', 5)          // stored as integer
     *      .addNumericParameter('rating', 4.5);         // stored as double
     * ```
     */
    addNumericParameter(key: string, value: number): this;
    /**
     * Adds a boolean parameter to the event.
     *
     * @param key - Parameter key. Must not be empty, must start with a letter,
     *              and can only contain lowercase letters, numbers, and underscores.
     * @param value - The boolean value to associate with the key
     * @returns This InsiderEvent instance for method chaining
     *
     * @example
     * ```typescript
     * event.addBooleanParameter('is_premium', true)
     *      .addBooleanParameter('has_discount', false);
     * ```
     */
    addBooleanParameter(key: string, value: boolean): this;
    /**
     * Adds a date parameter to the event.
     *
     * @param key - Parameter key. Must not be empty, must start with a letter,
     *              and can only contain lowercase letters, numbers, and underscores.
     * @param value - The date object to associate with the key
     * @returns This InsiderEvent instance for method chaining
     *
     * @example
     * ```typescript
     * event.addDateParameter('purchase_date', new Date())
     *      .addDateParameter('last_login', new Date('2023-12-01'));
     * ```
     */
    addDateParameter(key: string, value: Date): this;
    /**
     * Adds an array of strings parameter to the event.
     *
     * @param key - Parameter key. Must not be empty, must start with a letter,
     *              and can only contain lowercase letters, numbers, and underscores.
     * @param value - The array of strings to associate with the key
     * @returns This InsiderEvent instance for method chaining
     *
     * @example
     * ```typescript
     * event.addStringArrayParameter('categories', ['electronics', 'mobile', 'accessories'])
     *      .addStringArrayParameter('tags', ['new', 'featured', 'bestseller']);
     * ```
     */
    addStringArrayParameter(key: string, value: string[]): this;
    /**
     * Adds an array of numbers parameter to the event.
     *
     * @param key - Parameter key. Must not be empty, must start with a letter,
     *              and can only contain lowercase letters, numbers, and underscores.
     * @param value - The array of numbers to associate with the key
     * @returns This InsiderEvent instance for method chaining
     *
     * @example
     * ```typescript
     * event.addNumericArrayParameter('prices', [19.99, 29.99, 39.99])
     *      .addNumericArrayParameter('ratings', [4, 5, 3.5, 4]);
     * ```
     */
    addNumericArrayParameter(key: string, value: number[]): this;
    /**
     * Builds and sends the event with all added parameters to the native bridge.
     * This method should be called after adding all desired parameters to the event.
     *
     * @returns A Promise that resolves when the event has been successfully sent
     *
     * @example
     * ```typescript
     * const event = new InsiderEvent('user_action')
     *   .addStringParameter('action_type', 'click')
     *   .addNumericParameter('timestamp', Date.now());
     *
     * await event.build(); // Send the event
     * ```
     */
    build(): Promise<void>;
}

/**
 * Class representing user identifiers for the Insider SDK.
 *
 * This class helps unify the user's identity across Insider products and enables communication through various channels.
 * Allows adding various types of identifiers such as email, phone number, user ID, and custom key-value pairs.
 *
 * After configuring identifiers, they can be passed to the Insider user login method to associate the identifiers with the user.
 *
 * @example
 * ```typescript
 * const identifiers = new InsiderIdentifiers()
 *     .addEmail('heysem@example.com')
 *     .addPhoneNumber('+1234567890')
 *     .addUserID('user123')
 *     .addCustomIdentifier('loyalty_level', 'gold')
 *     .addCustomIdentifier('preferred_language', 'en');
 * ```
 */
declare class InsiderIdentifiers {
    /**
     * Adds an email address as a user identifier.
     *
     * @param email - The email address to associate with the user, must be a valid email format.
     * @returns This InsiderIdentifiers instance for method chaining
     */
    addEmail(email: string): this;
    /**
     * Adds a phone number as a user identifier.
     *
     * @param phoneNumber - The phone number to associate with the user, must be a valid phone number format.
     * @returns This InsiderIdentifiers instance for method chaining
     */
    addPhoneNumber(phoneNumber: string): this;
    /**
     * Adds a user ID as a user identifier.
     *
     * @param userID - The user ID to associate with the user, must be a non-empty string.
     * @returns This InsiderIdentifiers instance for method chaining
     */
    addUserID(userID: string): this;
    /**
     * Adds a custom identifier as a key-value pair.
     *
     * @param key - The key for the custom identifier.
     * @param value - The value for the custom identifier, must be a non-empty string.
     * @returns This InsiderIdentifiers instance for method chaining
     */
    addCustomIdentifier(key: string, value: string): this;
}

interface MessageCenterMessage {
    id: string;
    title: string;
    content: string;
    isRead: boolean;
    createdDate: string | number;
    imageUrl?: string;
    deepLink?: string;
    [key: string]: any;
}

declare class InsiderProduct {
    readonly id: string;
    readonly name: string;
    readonly taxonomy: string[];
    readonly imageUrl: string;
    readonly price: number;
    readonly currency: string;
    /**
     * Creates a new InsiderProduct instance.
     *
     * @param id - The unique identifier for the product
     * @param name - The name of the product
     * @param taxonomy - An array representing the product's category hierarchy
     * @param imageUrl - URL of the product image
     * @param price - The price of the product
     * @param currency - The currency code (e.g., "USD", "EUR") for the price
     *
     * @example
     * ```typescript
     * const product = new InsiderProduct(
     *   'prod123',
     *   'Smartphone XYZ',
     *   ['Electronics', 'Mobile Phones', 'Smartphones'],
     *   'https://example.com/images/prod123.jpg',
     *   699.99,
     *   'USD'
     * );
     * ```
     */
    constructor(id: string, name: string, taxonomy: string[], imageUrl: string, price: number, currency: string);
    get color(): string | undefined;
    /**
     * Sets the color of the product.
     *
     * @param color - The color value
     * @returns The current InsiderProduct instance for method chaining
     */
    setColor(color: string): this;
    get voucherName(): string | undefined;
    /**
     * Sets the voucher name for the product.
     *
     * @param voucherName - The voucher name
     * @returns The current InsiderProduct instance for method chaining
     */
    setVoucherName(voucherName: string): this;
    get promotionName(): string | undefined;
    /**
     * Sets the promotion name for the product.
     *
     * @param promotionName - The promotion name
     * @returns The current InsiderProduct instance for method chaining
     */
    setPromotionName(promotionName: string): this;
    get size(): string | undefined;
    /**
     * Sets the size of the product.
     *
     * @param size - The size value
     * @returns The current InsiderProduct instance for method chaining
     */
    setSize(size: string): this;
    get groupCode(): string | undefined;
    /**
     * Sets the group code for the product.
     *
     * @param groupCode - The group code
     * @returns The current InsiderProduct instance for method chaining
     */
    setGroupCode(groupCode: string): this;
    get salePrice(): number | undefined;
    /**
     * Sets the sale price of the product.
     *
     * @param salePrice - The sale price value
     * @returns The current InsiderProduct instance for method chaining
     */
    setSalePrice(salePrice: number): this;
    get shippingCost(): number | undefined;
    /**
     * Sets the shipping cost for the product.
     *
     * @param shippingCost - The shipping cost value
     * @returns The current InsiderProduct instance for method chaining
     */
    setShippingCost(shippingCost: number): this;
    get voucherDiscount(): number | undefined;
    /**
     * Sets the voucher discount for the product.
     *
     * @param voucherDiscount - The voucher discount value
     * @returns The current InsiderProduct instance for method chaining
     */
    setVoucherDiscount(voucherDiscount: number): this;
    get promotionDiscount(): number | undefined;
    /**
     * Sets the promotion discount for the product.
     *
     * @param promotionDiscount - The promotion discount value
     * @returns The current InsiderProduct instance for method chaining
     */
    setPromotionDiscount(promotionDiscount: number): this;
    get stock(): number | undefined;
    /**
     * Sets the stock quantity for the product.
     *
     * @param stock - The stock quantity
     * @returns The current InsiderProduct instance for method chaining
     */
    setStock(stock: number): this;
    get quantity(): number | undefined;
    /**
     * Sets the quantity for the product.
     *
     * @param quantity - The quantity value
     * @returns The current InsiderProduct instance for method chaining
     */
    setQuantity(quantity: number): this;
    get brand(): string | undefined;
    /**
     * Sets the brand of the product.
     *
     * @param brand - The brand name
     * @returns The current InsiderProduct instance for method chaining
     */
    setBrand(brand: string): this;
    get gender(): string | undefined;
    /**
     * Sets the gender for the product.
     *
     * @param gender - The gender value
     * @returns The current InsiderProduct instance for method chaining
     */
    setGender(gender: string): this;
    get description(): string | undefined;
    /**
     * Sets the description of the product.
     *
     * @param description - The product description
     * @returns The current InsiderProduct instance for method chaining
     */
    setDescription(description: string): this;
    get sku(): string | undefined;
    /**
     * Sets the SKU (Stock Keeping Unit) for the product.
     *
     * @param sku - The SKU value
     * @returns The current InsiderProduct instance for method chaining
     */
    setSku(sku: string): this;
    get multipack(): string | undefined;
    /**
     * Sets whether the product is a multipack.
     *
     * @param multipack - Boolean indicating if product is multipack
     * @returns The current InsiderProduct instance for method chaining
     */
    setMultipack(multipack: string): this;
    get productType(): string | undefined;
    /**
     * Sets the product type.
     *
     * @param productType - The product type
     * @returns The current InsiderProduct instance for method chaining
     */
    setProductType(productType: string): this;
    get gtin(): string | undefined;
    /**
     * Sets the GTIN (Global Trade Item Number) for the product.
     *
     * @param gtin - The GTIN value
     * @returns The current InsiderProduct instance for method chaining
     */
    setGtin(gtin: string): this;
    get tags(): string[] | undefined;
    /**
     * Sets the tags for the product.
     *
     * @param tags - An array of tag strings
     * @returns The current InsiderProduct instance for method chaining
     */
    setTags(tags: string[]): this;
    get inStock(): boolean | undefined;
    /**
     * Sets the in-stock status for the product.
     *
     * @param inStock - Boolean indicating if product is in stock
     * @returns The current InsiderProduct instance for method chaining
     */
    setInStock(inStock: boolean): this;
    get productUrl(): string | undefined;
    /**
     * Sets the product URL attribute for the product.
     *
     * @param productUrl - The product URL
     * @returns The current InsiderProduct instance for method chaining
     */
    setProductUrl(productUrl: string): this;
    /**
     * Sets a string custom attribute to the product.
     *
     * @param key - Parameter key. Must not be empty, must start with a letter,
     *              and can only contain lowercase letters, numbers, and underscores.
     * @param value - The string value to associate with the key
     * @returns This InsiderProduct instance for method chaining
     *
     * @example
     * ```typescript
     * product.setStringCustomAttribute('material', 'plastic')
     *        .setStringCustomAttribute('grade', 'A');
     * ```
     */
    setStringCustomAttribute(key: string, value: string): this;
    /**
     * Sets a numeric custom attribute to the product.
     * Automatically distinguishes between integer and double based on the value.
     *
     * @param key - Parameter key. Must not be empty, must start with a letter,
     *              and can only contain lowercase letters, numbers, and underscores.
     * @param value - The numeric value to associate with the key
     * @returns This InsiderProduct instance for method chaining
     *
     * @example
     * ```typescript
     * product.setNumericCustomAttribute('price', 29.99)         // stored as double
     *        .setNumericCustomAttribute('quantity', 5)          // stored as integer
     *        .setNumericCustomAttribute('rating', 4.5);         // stored as double
     * ```
     */
    setNumericCustomAttribute(key: string, value: number): this;
    /**
     * Sets a boolean custom attribute to the product.
     *
     * @param key - Parameter key. Must not be empty, must start with a letter,
     *              and can only contain lowercase letters, numbers, and underscores.
     * @param value - The boolean value to associate with the key
     * @returns This InsiderProduct instance for method chaining
     *
     * @example
     * ```typescript
     * product.setBooleanCustomAttribute('is_premium', true)
     *        .setBooleanCustomAttribute('has_discount', false);
     * ```
     */
    setBooleanCustomAttribute(key: string, value: boolean): this;
    /**
     * Sets a date custom attribute to the product.
     *
     * @param key - Parameter key. Must not be empty, must start with a letter,
     *              and can only contain lowercase letters, numbers, and underscores.
     * @param value - The date object to associate with the key
     * @returns This InsiderProduct instance for method chaining
     *
     * @example
     * ```typescript
     * product.setDateCustomAttribute('expiry_date', new Date())
     *        .setDateCustomAttribute('production_date', new Date('2023-12-01'));
     * ```
     */
    setDateCustomAttribute(key: string, value: Date): this;
    /**
     * Sets an array of strings as a custom attribute to the product.
     *
     * @param key - Parameter key. Must not be empty, must start with a letter,
     *              and can only contain lowercase letters, numbers, and underscores.
     * @param value - The array of strings to associate with the key
     * @returns This InsiderProduct instance for method chaining
     *
     * @example
     * ```typescript
     * product.setStringArrayCustomAttribute('categories', ['electronics', 'mobile', 'accessories'])
     *        .setStringArrayCustomAttribute('tags', ['new', 'featured', 'bestseller']);
     * ```
     */
    setStringArrayCustomAttribute(key: string, value: string[]): this;
    /**
     * Sets an array of numbers as a custom attribute to the product.
     *
     * @param key - Parameter key. Must not be empty, must start with a letter,
     *              and can only contain lowercase letters, numbers, and underscores.
     * @param value - The array of numbers to associate with the key
     * @returns This InsiderProduct instance for method chaining
     *
     * @example
     * ```typescript
     * product.setNumericArrayCustomAttribute('prices', [19.99, 29.99, 39.99])
     *        .setNumericArrayCustomAttribute('ratings', [4, 5, 3.5, 4]);
     * ```
     */
    setNumericArrayCustomAttribute(key: string, value: number[]): this;
}

/**
 * Represents an Insider user and provides login/logout functionality.
 * Use the static `shared` instance for global access.
 */
declare class InsiderUser {
    static shared: InsiderUser;
    private constructor();
    /**
     * Logs in the user with the provided identifiers.
     * @param identifiers - The identifiers for the user.
     * @returns A promise that resolves with a string result from the native bridge.
     */
    login(identifiers: InsiderIdentifiers): Promise<string | null>;
    /**
     * Logs out the user.
     * @returns A promise that resolves when the logout is complete.
     */
    logout(): Promise<void>;
    /**
     * Logs out the user and resets the Insider ID, then logs in with additional identifiers.
     * This method performs a separation process that creates a new Insider ID while preserving
     * the provided additional identifiers.
     *
     * @param additionalIdentifiers - An array of InsiderIdentifiers to associate with the new Insider ID.
     *                                 Pass null, undefined, or an empty array to logout without additional identifiers.
     * @returns A promise that resolves with the new Insider ID (string) or null if the operation fails.
     */
    logoutResettingInsiderID(additionalIdentifiers?: InsiderIdentifiers[] | null): Promise<string | null>;
    /**
     * Sets the user's gender attribute.
     *
     * @param gender - The gender value ('male', 'female', or 'other')
     * @returns A promise that resolves when the attribute is set
     */
    setGender(gender: 'male' | 'female' | 'other'): Promise<void>;
    /**
     * Sets the user's birthday attribute.
     *
     * @param birthday - The user's birth date
     * @returns A promise that resolves when the attribute is set
     */
    setBirthday(birthday: Date): Promise<void>;
    /**
     * Sets the user's name attribute.
     *
     * @param name - The user's first name
     * @returns A promise that resolves when the attribute is set
     */
    setName(name: string): Promise<void>;
    /**
     * Sets the user's surname attribute.
     *
     * @param surname - The user's last name
     * @returns A promise that resolves when the attribute is set
     */
    setSurname(surname: string): Promise<void>;
    /**
     * Sets the user's age attribute.
     *
     * @param age - The user's age (must be non-negative)
     * @returns A promise that resolves when the attribute is set
     */
    setAge(age: number): Promise<void>;
    /**
     * Sets the user's email attribute.
     *
     * @param email - The user's email address
     * @returns A promise that resolves when the attribute is set, or rejects if validation fails
     */
    setEmail(email: string): Promise<void>;
    /**
     * Sets the user's phone number attribute.
     *
     * @param phoneNumber - The user's phone number
     * @returns A promise that resolves when the attribute is set, or rejects if validation fails
     */
    setPhoneNumber(phoneNumber: string): Promise<void>;
    /**
     * Sets the user's language attribute.
     *
     * @param language - The user's preferred language code (e.g., 'en', 'tr')
     * @returns A promise that resolves when the attribute is set
     */
    setLanguage(language: string): Promise<void>;
    /**
     * Sets the user's locale attribute.
     *
     * @param locale - The user's locale code (e.g., 'en_US', 'tr_TR')
     * @returns A promise that resolves when the attribute is set
     */
    setLocale(locale: string): Promise<void>;
    /**
     * Sets the user's SMS opt-in preference.
     *
     * @param smsOptin - True to enable SMS notifications, false to disable
     * @returns A promise that resolves when the attribute is set
     */
    setSMSOptin(smsOptin: boolean): Promise<void>;
    /**
     * Sets the user's email opt-in preference.
     *
     * @param emailOptin - True to enable email notifications, false to disable
     * @returns A promise that resolves when the attribute is set
     */
    setEmailOptin(emailOptin: boolean): Promise<void>;
    /**
     * Sets the user's WhatsApp opt-in preference.
     *
     * @param whatsappOptin - True to enable WhatsApp notifications, false to disable
     * @returns A promise that resolves when the attribute is set
     */
    setWhatsappOptin(whatsappOptin: boolean): Promise<void>;
    /**
     * Sets the user's push notification opt-in preference.
     * If you pass false, that device won't be able to receive push notifications until it's set back to true.
     *
     * @param pushOptin - True to enable push notifications, false to disable
     * @returns A promise that resolves when the attribute is set
     */
    setPushOptin(pushOptin: boolean): Promise<void>;
    /**
     * Sets the user's location opt-in preference.
     * If you pass false, Insider Geofencing will stop working until it's set back to true.
     *
     * @param locationOptin - True to enable location tracking, false to disable
     * @returns A promise that resolves when the attribute is set
     */
    setLocationOptin(locationOptin: boolean): Promise<void>;
    /**
     * Sets a custom string attribute for the user.
     *
     * @param key - The attribute key
     * @param value - The string value
     * @returns A promise that resolves when the attribute is set
     */
    setStringCustomAttribute(key: string, value: string): Promise<void>;
    /**
     * Sets a custom numeric attribute for the user.
     * Automatically distinguishes between integer and double based on the value.
     *
     * @param key - The attribute key
     * @param value - The numeric value (automatically stored as integer or double)
     * @returns A promise that resolves when the attribute is set
     *
     * @example
     * ```typescript
     * currentUser.setNumericCustomAttribute('loyalty_points', 1500)    // stored as integer
     *            .setNumericCustomAttribute('account_balance', 2549.99) // stored as double
     *            .setNumericCustomAttribute('rating', 4.5);              // stored as double
     * ```
     */
    setNumericCustomAttribute(key: string, value: number): Promise<void>;
    /**
     * Sets a custom boolean attribute for the user.
     * Your attribute key should be all lowercase and should not include any special or non-Latin characters.
     *
     * @param key - The attribute key
     * @param value - The boolean value
     * @returns A promise that resolves when the attribute is set
     */
    setBooleanCustomAttribute(key: string, value: boolean): Promise<void>;
    /**
     * Sets a custom date attribute for the user.
     * Your attribute key should be all lowercase and should not include any special or non-Latin characters.
     *
     * @param key - The attribute key
     * @param value - The date value
     * @returns A promise that resolves when the attribute is set
     */
    setDateCustomAttribute(key: string, value: Date): Promise<void>;
    /**
     * Sets a custom string array attribute for the user.
     * Your attribute key should be all lowercase and should not include any special or non-Latin characters.
     *
     * @param key - The attribute key
     * @param value - The array of strings
     * @returns A promise that resolves when the attribute is set
     */
    setArrayCustomAttribute(key: string, value: string[]): Promise<void>;
    /**
     * Unsets a custom attribute from the user.
     * Your attribute key should be all lowercase and should not include any special or non-Latin characters.
     *
     * @param key - The attribute key to remove
     * @returns A promise that resolves when the attribute is unset
     */
    unsetCustomAttribute(key: string): Promise<void>;
}

type ParameterScalar = string | number | boolean | Date;
type ParameterList = ParameterScalar[];
type ParameterValue = ParameterScalar | ParameterList;
type ParameterMap = Record<string, ParameterValue>;

declare global {
    interface Window {
        /**
         * Provides bridge methods to interact with the Insider SDK.
         */
        insider: Insider;
    }
}
interface Insider {
    closeButtonPosition: typeof CloseButtonPosition;
    getInsiderID(): Promise<string | null>;
    getCurrentUser(): InsiderUser;
    tagEvent(eventName: string): InsiderEvent;
    createNewProduct(productId: string, productName: string, taxonomy: string[], imageUrl: string, price: number, currency: string): InsiderProduct;
    createIdentifiers(): InsiderIdentifiers;
    /**
     * Logs a sign-up confirmation event.
     * Call this method when the user completes the sign-up process.
     *
     * @param customParameters A record of custom key-value pairs to attach to the event.
     * @returns A Promise that resolves when the sign-up confirmation event has been successfully logged.
     */
    signUpConfirmation(customParameters?: ParameterMap): Promise<void>;
    enableCarrierCollection(enable: boolean): Promise<void>;
    getMessageCenterData(startDate: Date, endDate: Date, limit: number): Promise<MessageCenterMessage[]>;
    setGDPRConsent(consent: boolean): Promise<void>;
    setMobileAppAccess(access: boolean): Promise<void>;
    enableIpCollection(enable: boolean): Promise<void>;
    enableLocationCollection(enable: boolean): Promise<void>;
    /**
     * Logs an event indicating that the user has visited the home page.
     * Call this method each time when the user views the home page.
     *
     * @param customParameters A record of custom key-value pairs to attach to the event.
     * @returns A Promise that resolves when the event has been successfully logged.
     */
    visitHomePage(customParameters?: ParameterMap): Promise<void>;
    /**
     * Logs an event indicating that the user has visited a listing page with the specified taxonomy.
     * Call this method each time when the user views a listing page.
     *
     * @param taxonomy An array of strings representing the taxonomy of the listing page.
     * @param customParameters A record of custom key-value pairs to attach to the event.
     * @returns A Promise that resolves when the event has been successfully logged.
     */
    visitListingPage(taxonomy: string[], customParameters?: ParameterMap): Promise<void>;
    /**
     * Sets the position of the close button in the internal browser.
     * This method allows you to customize where the close button appears when opening URLs in the internal browser.
     *
     * @param position The position of the close button. Use CloseButtonPosition enum values: LEFT, RIGHT, or NONE.
     * @returns A Promise that resolves when the position has been successfully set.
     * @see CloseButtonPosition
     */
    setInternalBrowserCloseButtonPosition(position: CloseButtonPosition): Promise<void>;
    /**
     * Logs an event indicating that the user has visited the product details page for a specific product.
     * Call this method each time when the user views a product's details.
     *
     * @param product The product that was viewed, represented as an InsiderProduct instance.
     * @param customParameters A record of custom key-value pairs to attach to the event.
     * @returns A Promise that resolves when the event has been successfully logged.
     * @see InsiderProduct
     */
    visitProductDetailsPage(product: InsiderProduct, customParameters?: ParameterMap): Promise<void>;
    /**
     * Logs an event indicating that the user has visited the cart page with the specified products.
     * Call this method each time when the user views their cart.
     *
     * @param products An array of InsiderProduct instances representing the products in the cart.
     * @param customParameters A record of custom key-value pairs to attach to the event.
     * @returns A Promise that resolves when the event has been successfully logged.
     * @see InsiderProduct
     */
    visitCartPage(products: InsiderProduct[], customParameters?: ParameterMap): Promise<void>;
    /**
     * Logs an event indicating that an item has been added to the cart.
     * Call this method each time when the user adds a product to their cart.
     *
     * @param product The product that was added to the cart, represented as an InsiderProduct instance.
     * @param customParameters A record of custom key-value pairs to attach to the event.
     * @returns A Promise that resolves when the event has been successfully logged.
     * @see InsiderProduct
     */
    itemAddedToCart(product: InsiderProduct, customParameters?: ParameterMap): Promise<void>;
    /**
     * Logs an event indicating that an item has been removed from the cart.
     * Call this method each time when the user removes a product from their cart.
     *
     * @param productId The unique identifier of the product that was removed from the cart.
     * @param customParameters A record of custom key-value pairs to attach to the event.
     * @returns A Promise that resolves when the event has been successfully logged.
     */
    itemRemovedFromCart(productId: string, customParameters?: ParameterMap): Promise<void>;
    /**
     * Logs an event indicating that the user's cart has been cleared.
     * Call this method when the user clears all items from their cart.
     *
     * @param customParameters A record of custom key-value pairs to attach to the event.
     * @returns A Promise that resolves when the event has been successfully logged.
     */
    cartCleared(customParameters?: ParameterMap): Promise<void>;
    /**
     * Logs a purchase event with the given sale ID, product details, and optional custom parameters.
     * This method allows you to track sales and revenue.
     *
     * @param saleId A unique identifier for the sale transaction.
     * @param product The product that was purchased, represented as an InsiderProduct instance.
     * @param customParameters A record of custom key-value pairs to attach to the purchase event.
     * @returns A Promise that resolves when the purchase event has been successfully logged.
     * @see InsiderProduct
     */
    itemPurchased(saleId: string, product: InsiderProduct, customParameters?: ParameterMap): Promise<void>;
    /**
     * Enables the display of InApp messages for the current session.
     * Call this to re-enable InApp messages during the session.
     *
     * @returns A Promise that resolves when InApp messages have been successfully enabled.
     */
    enableInAppMessages(): Promise<void>;
    /**
     * Disables the display of InApp messages for the current session.
     * Call this to stop InApp messages during the session.
     *
     * @returns A Promise that resolves when InApp messages have been successfully disabled.
     */
    disableInAppMessages(): Promise<void>;
    /**
     * Removes any existing InApps including SocialProof on the screen.
     *
     * @returns A Promise that resolves when the InApp has been successfully removed.
     */
    removeInapp(): Promise<void>;
    /**
     * Registers push notification with quiet permission (iOS only).
     * On iOS 12 and above, this enables or disables the "deliver quietly" option.
     * On iOS below 12, this method will prompt notification permission regardless of the parameter.
     *
     * @param enabled Whether deliver quietly option should be enabled or not.
     * @returns A Promise that resolves when the registration has been completed.
     */
    registerWithQuietPermission(enabled: boolean): Promise<void>;
    /**
     * Logs an event indicating that the user has visited the wishlist page with the specified products.
     * Call this method each time when the user views their wishlist.
     *
     * @param products An array of InsiderProduct instances representing the products in the wishlist.
     * @param customParameters A record of custom key-value pairs to attach to the event.
     * @returns A Promise that resolves when the event has been successfully logged.
     * @see InsiderProduct
     */
    visitWishlist(products: InsiderProduct[], customParameters?: ParameterMap): Promise<void>;
    /**
     * Logs an event indicating that a product has been added to the wishlist.
     * Call this method each time when the user adds a product to their wishlist.
     *
     * @param product The product that was added to the wishlist, represented as an InsiderProduct instance.
     * @param customParameters A record of custom key-value pairs to attach to the event.
     * @returns A Promise that resolves when the event has been successfully logged.
     * @see InsiderProduct
     */
    itemAddedToWishlist(product: InsiderProduct, customParameters?: ParameterMap): Promise<void>;
    /**
     * Logs an event indicating that a product has been removed from the wishlist.
     * Call this method each time when the user removes a product from their wishlist.
     *
     * @param productId The unique identifier of the product that was removed from the wishlist.
     * @param customParameters A record of custom key-value pairs to attach to the event.
     * @returns A Promise that resolves when the event has been successfully logged.
     * @see InsiderProduct
     */
    itemRemovedFromWishlist(productId: string, customParameters?: ParameterMap): Promise<void>;
    /**
     * Logs an event indicating that the user's wishlist has been cleared.
     * Call this method when the user clears all items from their wishlist.
     *
     * @param customParameters A record of custom key-value pairs to attach to the event.
     * @returns A Promise that resolves when the event has been successfully logged.
     */
    wishlistCleared(customParameters?: ParameterMap): Promise<void>;
    /**
     * Starts geofence tracking to receive region enter and exit events.
     * Call this method to begin monitoring geofences on the device.
     *
     * @returns A Promise that resolves when geofence tracking has successfully started.
     */
    startTrackingGeofence(): Promise<void>;
    /**
     * Turns on or off monitoring region enter and exit events in the background.
     * By default, geofence tracking works only in foreground.
     * Call this method before beginning monitoring geofences on the device.
     *
     * @param allowsBackgroundLocationUpdates Whether monitoring region enter and exit events should be enabled or not.
     * @returns A Promise that resolves.
     */
    setAllowsBackgroundLocationUpdates(allowsBackgroundLocationUpdates: boolean): Promise<void>;
    /**
     * Registers a listener to receive Insider ID updates.
     * The provided listener will be invoked whenever the Insider ID changes or becomes available.
     *
     * @param listener - A callback function that receives the updated Insider ID value, or `null` if unavailable.
     * @returns A {@link InsiderListenerRegistration} object that can be used to remove the listener when no longer needed.
     */
    registerInsiderIDListener(listener: InsiderIDListener): InsiderListenerRegistration;
}

export { CloseButtonPosition, InsiderEvent, InsiderIdentifiers, InsiderProduct, InsiderUser };
export type { Insider, InsiderIDListener, InsiderListenerRegistration };
