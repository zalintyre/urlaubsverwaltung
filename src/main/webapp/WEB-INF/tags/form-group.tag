<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="uv" tagdir="/WEB-INF/tags" %>

<%@attribute name="required" type="java.lang.Boolean" required="false" %>
<%@attribute name="label" fragment="true" required="true" %>
<%@attribute name="input" fragment="true" required="true" %>
<%@attribute name="error" fragment="true" required="false" %>

<c:set var="required" value="${required == null ? false : required}" />

<c:set var="formGroupCssClass" value="${required ? 'is-required' : ''}" />

<div class="form-group ${formGroupCssClass} clearfix">
    <span class="control-label col-md-3 tw-leading-snug">
        <jsp:invoke fragment="label" />
    </span>
    <div class="col-md-9">
        <jsp:invoke fragment="input" />
        <c:if test="${not empty error}">
            <small class="help-inline">
                <jsp:invoke fragment="error" />
            </small>
        </c:if>
    </div>
</div>

