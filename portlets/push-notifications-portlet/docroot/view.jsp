<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/init.jsp" %>

<%
String androidApiKey = PrefsPropsUtil.getString(PortletPropsKeys.ANDROID_API_KEY, PortletPropsValues.ANDROID_API_KEY);
int androidRetries = PrefsPropsUtil.getInteger(PortletPropsKeys.ANDROID_RETRIES, PortletPropsValues.ANDROID_RETRIES);
String appleCertificatePassword = PrefsPropsUtil.getString(PortletPropsKeys.APPLE_CERTIFICATE_PASSWORD, PortletPropsValues.APPLE_CERTIFICATE_PASSWORD);
String appleCertificatePath = PrefsPropsUtil.getString(PortletPropsKeys.APPLE_CERTIFICATE_PATH, PortletPropsValues.APPLE_CERTIFICATE_PATH);
boolean appleSandbox = PrefsPropsUtil.getBoolean(PortletPropsKeys.APPLE_SANDBOX, PortletPropsValues.APPLE_SANDBOX);
%>

<liferay-portlet:actionURL name="updatePortletPreferences" var="updatePortletPreferencesURL" />

<liferay-ui:tabs
	names="configuration,test"
	refresh="<%= false %>"
>
	<liferay-ui:section>
		<aui:form action="<%= updatePortletPreferencesURL %>" method="post" name="configurationFm">
			<aui:fieldset label="android">
				<aui:input helpMessage="android-api-key-help" label="android-api-key" name="androidApiKey" type="text" value="<%= androidApiKey %>" wrapperCssClass="lfr-input-text-container" />

				<aui:input helpMessage="android-retries-help" label="android-retries" name="androidRetries" type="text" value="<%= androidRetries %>" wrapperCssClass="lfr-input-text-container">
					<aui:validator name="digits" />
					<aui:validator name="min">0</aui:validator>
				</aui:input>
			</aui:fieldset>

			<aui:fieldset label="ios">
				<aui:input helpMessage="apple-certificate-path-help" label="apple-certificate-path" name="appleCertificatePath" type="text" value="<%= appleCertificatePath %>" wrapperCssClass="lfr-input-text-container" />

				<aui:input helpMessage="apple-certificate-password-help" label="apple-certificate-password" name="appleCertificatePassword" type="password" value="<%= appleCertificatePassword %>" wrapperCssClass="lfr-input-text-container" />

				<aui:fieldset>
					<aui:input helpMessage="apple-sandbox-help" label="apple-sandbox"  name="appleSandbox" type="checkbox" value="<%= appleSandbox %>" />
				</aui:fieldset>
			</aui:fieldset>

			<aui:button-row>
				<aui:button type="submit" />
			</aui:button-row>
		</aui:form>
	</liferay-ui:section>

	<liferay-ui:section>
		<aui:form name="fm">
			<aui:input label="message" name="message" rows="6" type="textarea" />

			<aui:button type="submit" value="send" />

			<aui:button type="reset" value="reset" />
		</aui:form>

		<br />

		<div class="alert alert-success hide" id="<portlet:namespace />success">
			<p><liferay-ui:message key="the-push-notification-was-sent-successfully" /></p>
		</div>

		<div class="alert alert-danger hide" id="<portlet:namespace />error">
			<p></p>
		</div>
	</liferay-ui:section>
</liferay-ui:tabs>

<aui:script use="aui-base">
	var form = A.one('#<portlet:namespace />fm');

	form.on(
		'submit',
		function(event) {
			event.halt();

			var message = form.one('textarea[name="<portlet:namespace />message"]').val();

			Liferay.Service(
				'/push-notifications-portlet.pushnotificationsdevice/send-push-notification',
				{
					payload: A.JSON.stringify(
						{
							message: message
						}
					),
					toUserId: 0
				},
				<portlet:namespace />onSendPushNotification
			);
		}
	);

	function <portlet:namespace />onSendPushNotification(result) {
		var success = A.one('#<portlet:namespace />success');

		success.hide();

		var error = A.one('#<portlet:namespace />error');

		error.hide();

		if (A.Object.hasKey(result, 'exception')) {
			error.one('p').text(result);

			error.show();
		}
		else {
			success.show();
		}
	}
</aui:script>