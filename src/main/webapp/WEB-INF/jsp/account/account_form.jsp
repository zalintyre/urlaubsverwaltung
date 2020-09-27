<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="uv" tagdir="/WEB-INF/tags" %>
<%@taglib prefix="asset" uri = "/WEB-INF/asset.tld"%>

<!DOCTYPE html>
<html lang="${language}">
<head>
    <title>
        <spring:message code="person.form.annualVacation.header.title" arguments="${person.niceName}"/>
    </title>
    <uv:custom-head/>
    <script defer src="<asset:url value='account_form.js' />"></script>
</head>

<body>

<uv:menu/>

<spring:url var="URL_PREFIX" value="/web"/>

<c:set var="DATE_PATTERN">
    <spring:message code="pattern.date"/>
</c:set>

<c:set var="COMMENT_PLACEHOLDER">
    <spring:message code="person.form.annualVacation.comment.placeholder"/>
</c:set>

<div class="content">
    <div class="container">

        <form:form method="POST" action="${URL_PREFIX}/person/${person.id}/account"
                   modelAttribute="account" class="form-horizontal">

            <form:hidden path="holidaysAccountYear"/>

            <div class="form-section">

                <uv:section-heading>
                    <h1>
                        <spring:message code="person.form.annualVacation.title" arguments="${person.niceName}"/>
                    </h1>
                    <uv:year-selector year="${year}" hrefPrefix="${URL_PREFIX}/person/${person.id}/account?year="/>
                </uv:section-heading>

                <c:if test="${not empty errors}">
                <div class="row tw-mb-8">
                    <div class="col-xs-12">
                        <div class="alert alert-danger"><form:errors cssClass="error"/></div>
                    </div>
                </div>
                </c:if>

                <div class="row tw-mb-16">
                    <div class="col-md-4 col-md-push-8">
                        <span class="help-block tw-text-sm">
                            <uv:icon-information-circle className="tw-w-4 tw-h-4" solid="true" />
                            <spring:message code="person.form.annualVacation.description"/>
                        </span>
                    </div>

                    <div class="col-md-8 col-md-pull-4">
                        <uv:form-group>
                            <jsp:attribute name="label">
                                <uv:form-label htmlFor="holidaysAccountValidFrom">
                                    <spring:message code="person.form.annualVacation.period.start"/>:
                                </uv:form-label>
                            </jsp:attribute>
                            <jsp:attribute name="input">
                                <uv:form-input
                                    id="holidaysAccountValidFrom"
                                    path="holidaysAccountValidFrom"
                                    placeholder="${DATE_PATTERN}"
                                />
                            </jsp:attribute>
                            <jsp:attribute name="error">
                                <form:errors path="holidaysAccountValidFrom" cssClass="error"/>
                            </jsp:attribute>
                        </uv:form-group>

                        <uv:form-group required="true">
                            <jsp:attribute name="label">
                                <uv:form-label htmlFor="holidaysAccountValidTo">
                                    <spring:message code="person.form.annualVacation.period.end"/>:
                                </uv:form-label>
                            </jsp:attribute>
                            <jsp:attribute name="input">
                                <uv:form-input
                                    id="holidaysAccountValidTo"
                                    path="holidaysAccountValidTo"
                                    placeholder="${DATE_PATTERN}"
                                />
                            </jsp:attribute>
                            <jsp:attribute name="error">
                                <form:errors path="holidaysAccountValidTo" cssClass="error"/>
                            </jsp:attribute>
                        </uv:form-group>

                        <uv:form-group required="true">
                            <jsp:attribute name="label">
                                <uv:form-label htmlFor="annualVacationDays">
                                    <spring:message code='person.form.annualVacation.annualVacation'/>:
                                </uv:form-label>
                            </jsp:attribute>
                            <jsp:attribute name="input">
                                <uv:form-input-number
                                    id="annualVacationDays"
                                    path="annualVacationDays"
                                    value="${account.annualVacationDays}"
                                    step="1"
                                />
                            </jsp:attribute>
                            <jsp:attribute name="error">
                                <form:errors path="annualVacationDays" cssClass="error"/>
                            </jsp:attribute>
                        </uv:form-group>

                        <uv:form-group required="true">
                            <jsp:attribute name="label">
                                <uv:form-label htmlFor="actualVacationDays">
                                    <spring:message code='person.form.annualVacation.actualVacation'/>:
                                </uv:form-label>
                            </jsp:attribute>
                            <jsp:attribute name="input">
                                <uv:form-input-number
                                    id="actualVacationDays"
                                    path="actualVacationDays"
                                    value="${account.actualVacationDays}"
                                    step="0.5"
                                />
                            </jsp:attribute>
                            <jsp:attribute name="error">
                                <form:errors path="actualVacationDays" cssClass="error"/>
                            </jsp:attribute>
                        </uv:form-group>

                        <uv:form-group required="true">
                            <jsp:attribute name="label">
                                <uv:form-label htmlFor="remainingVacationDays">
                                    <spring:message code="person.form.annualVacation.remainingVacation"/>:
                                </uv:form-label>
                            </jsp:attribute>
                            <jsp:attribute name="input">
                                <uv:form-input-number
                                    id="remainingVacationDays"
                                    path="remainingVacationDays"
                                    value="${account.remainingVacationDays}"
                                    step="0.5"
                                />
                            </jsp:attribute>
                            <jsp:attribute name="error">
                                <form:errors path="remainingVacationDays" cssClass="error"/>
                            </jsp:attribute>
                        </uv:form-group>

                        <uv:form-group required="true">
                            <jsp:attribute name="label">
                                <uv:form-label htmlFor="">
                                    <spring:message code="person.form.annualVacation.remainingVacation.notExpiring"/>:
                                </uv:form-label>
                            </jsp:attribute>
                            <jsp:attribute name="input">
                                <uv:form-input-number
                                    id="remainingVacationDaysNotExpiring"
                                    value="${account.remainingVacationDaysNotExpiring}"
                                    path="remainingVacationDaysNotExpiring"
                                    step="0.5"
                                />
                            </jsp:attribute>
                            <jsp:attribute name="error">
                                <form:errors path="remainingVacationDaysNotExpiring" cssClass="error"/>
                            </jsp:attribute>
                        </uv:form-group>

                        <uv:form-group>
                            <jsp:attribute name="label">
                                <uv:form-label htmlFor="">
                                    <spring:message code='person.form.annualVacation.comment'/>:
                                </uv:form-label>
                            </jsp:attribute>
                            <jsp:attribute name="input">
                                <small>
                                    <span id="text-comment"></span> <spring:message code='action.comment.maxChars'/>
                                </small>
                                <form:textarea id="comment" rows="3" path="comment" class="form-control"
                                               cssErrorClass="form-control error"
                                               onkeyup="count(this.value, 'text-comment');"
                                               onkeydown="maxChars(this,200); count(this.value, 'text-comment');"
                                               placeholder="${COMMENT_PLACEHOLDER}"/>
                            </jsp:attribute>
                            <jsp:attribute name="error">
                                <form:errors path="comment" cssClass="error"/>
                            </jsp:attribute>
                        </uv:form-group>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <div class="row tw-mb-16">
                    <div class="col-xs-12">
                        <button class="btn btn-success col-xs-12 col-sm-5 col-md-2" type="submit"><spring:message
                            code="action.save"/></button>
                        <button type="button" class="btn btn-default back col-xs-12 col-sm-5 col-md-2 pull-right">
                            <spring:message code="action.cancel"/>
                        </button>
                    </div>
                </div>
            </div>

        </form:form>
    </div>
</div>
</body>
</html>
