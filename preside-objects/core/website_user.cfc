/**
 * @seederEnable    true
 */
component {
	property name="login_id"      seederClass="name.username" seederSuffix="@gmail.com";
	property name="email_address" seederSameAs="login_id";
	property name="display_name"  seederClass="name.fullName";
}