<%--
/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
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

<%@ include file="/html/portlet/journal/init.jsp" %>

<style type="text/css">
	.portlet-journal .article-toolbar .icon-download {
		background-image: none;
	}
</style>

<liferay-util:buffer var="html">
	<liferay-util:include page="/html/portlet/journal/article_toolbar.portal.jsp" />
</liferay-util:buffer>

<%
int index = html.indexOf("<portlet:renderURL var=\"viewHistoryURL\">");
%>

<c:choose>
	<c:when test="<%= index > 0 %>">
		<%= html.substring(0, x) %>

		<%
		JournalArticle article = (JournalArticle)request.getAttribute(WebKeys.JOURNAL_ARTICLE);

		String structureId = BeanParamUtil.getString(article, request, "structureId");
		%>

		<c:if test="<%= (article != null) && Validator.isNotNull(structureId) %>">
			toolbarButtonGroup.push(
				{
					icon: 'icon-download',
					label: '<%= UnicodeLanguageUtil.get(pageContext, "download") %>',
					on: {
						click: function(event) {
							event.domEvent.preventDefault();

							var downloadArticleContent = Liferay.Util.openWindow(
								{
									dialog: {
										bodyContent: '<pre><%= HtmlUtil.escapeJS(HtmlUtil.escape(article.getContent())) %></pre>',
										modal: true
									},
									id: '<portlet:namespace />articleDownload',
									title: '<%= article.getTitle(locale) %>'
								}
							);
						}
					}
				}
			);
		</c:if>

		<%= html.substring(x) %>
	</c:when>
	<c:otherwise>
		<%= html %>
	</c:otherwise>
</c:choose>