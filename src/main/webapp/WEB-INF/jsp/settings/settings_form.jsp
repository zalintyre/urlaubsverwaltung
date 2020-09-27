<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="uv" tagdir="/WEB-INF/tags" %>
<%@taglib prefix="person" tagdir="/WEB-INF/tags/person" %>
<%@taglib prefix="asset" uri="/WEB-INF/asset.tld" %>

<!DOCTYPE html>
<html lang="${language}">

<head>
    <title>
        <spring:message code="settings.header.title"/>
    </title>
    <uv:custom-head/>
    <link rel="stylesheet" type="text/css" href="<asset:url value='npm.chosen-js.css' />"/>
    <script defer src="<asset:url value='npm.chosen-js.js' />"></script>
    <script defer src="<asset:url value='settings_form.js' />"></script>
</head>

<body>

<uv:menu/>

<spring:url var="URL_PREFIX" value="/web"/>

<h1 class="tw-sr-only"><spring:message code="settings.header.title" /></h1>

<div class="content">
    <div class="container">
        <form:form method="POST" action="${URL_PREFIX}/settings" modelAttribute="settings" class="form-horizontal" role="form">
            <form:hidden path="id"/>
            <button type="submit" hidden></button>

            <div class="row tw-mb-4">
                <div class="col-xs-12 feedback">
                    <c:if test="${not empty errors}">
                        <div class="alert alert-danger">
                            <spring:message code="settings.action.update.error"/>
                        </div>
                    </c:if>
                    <c:if test="${success}">
                        <div class="alert alert-success">
                            <spring:message code="settings.action.update.success"/>
                        </div>
                    </c:if>
                </div>
            </div>

            <c:set var="absenceError">
                <form:errors path="absenceSettings.*"/>
            </c:set>
            <c:if test="${not empty absenceError}">
                <c:set var="ABSENCE_ERROR_CSS_CLASS" value="error"/>
            </c:if>

            <c:set var="workingTimeError">
                <form:errors path="workingTimeSettings.*"/>
            </c:set>
            <c:if test="${not empty workingTimeError}">
                <c:set var="WORKING_TIME_ERROR_CSS_CLASS" value="error"/>
            </c:if>

            <c:set var="calendarError">
                <form:errors path="calendarSettings.*"/>
            </c:set>
            <c:if test="${not empty calendarError}">
                <c:set var="CALENDAR_ERROR_CSS_CLASS" value="error"/>
            </c:if>

            <div class="row">
                <div class="col-xs-12">
                    <ul class="nav nav-tabs" role="tablist">
                        <li role="presentation" class="active ${ABSENCE_ERROR_CSS_CLASS}">
                            <a href="#absence" aria-controls="absence" role="tab" data-toggle="tab"><spring:message
                                code="settings.tabs.absence"/></a>
                        </li>
                        <li role="presentation" class="${WORKING_TIME_ERROR_CSS_CLASS}">
                            <a href="#publicHolidays" aria-controls="publicHolidays" role="tab"
                               data-toggle="tab"><spring:message code="settings.tabs.workingTime"/></a>
                        </li>
                        <li role="presentation" class="${CALENDAR_ERROR_CSS_CLASS}">
                            <a href="#calendar" aria-controls="calendar" role="tab" data-toggle="tab"><spring:message
                                code="settings.tabs.calendar"/></a>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="tab-content tw-mb-16">

                <div class="tab-pane active" id="absence">
                    <div class="form-section tw-mb-8">
                        <uv:section-heading>
                            <h2>
                                <spring:message code="settings.vacation.title"/>
                            </h2>
                        </uv:section-heading>
                        <div class="row">
                            <div class="col-md-4 col-md-push-8">
                                <span class="help-block tw-text-sm">
                                    <uv:icon-information-circle className="tw-w-4 tw-h-4" solid="true" />
                                    <spring:message code="settings.vacation.description"/>
                                </span>
                            </div>
                            <div class="col-md-8 col-md-pull-4">
                                <uv:form-group required="true">
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="absenceSettings.maximumAnnualVacationDays">
                                            <spring:message code='settings.vacation.maximumAnnualVacationDays'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input-number
                                            id="absenceSettings.maximumAnnualVacationDays"
                                            path="absenceSettings.maximumAnnualVacationDays"
                                            step="1"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="absenceSettings.maximumAnnualVacationDays" />
                                    </jsp:attribute>
                                </uv:form-group>
                                <uv:form-group required="true">
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="absenceSettings.maximumMonthsToApplyForLeaveInAdvance">
                                            <spring:message code='settings.vacation.maximumMonthsToApplyForLeaveInAdvance'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input-number
                                            id="absenceSettings.maximumMonthsToApplyForLeaveInAdvance"
                                            path="absenceSettings.maximumMonthsToApplyForLeaveInAdvance"
                                            step="1"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="absenceSettings.maximumMonthsToApplyForLeaveInAdvance" />
                                    </jsp:attribute>
                                </uv:form-group>
                            </div>
                        </div>
                    </div>

                    <div class="form-section tw-mb-8">
                        <uv:section-heading>
                            <h2>
                                <spring:message code="settings.vacation.remindForWaitingApplications.title"/>
                            </h2>
                        </uv:section-heading>
                        <div class="row">
                            <div class="col-md-4 col-md-push-8">
                                <span class="help-block tw-text-sm">
                                    <uv:icon-information-circle className="tw-w-4 tw-h-4" solid="true" />
                                    <spring:message code="settings.vacation.daysBeforeRemindForWaitingApplications.descripton"/>
                                </span>
                            </div>
                            <div class="col-md-8 col-md-pull-4">
                                <uv:form-group required="true">
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="absenceSettings.remindForWaitingApplications.true">
                                            <spring:message code='settings.vacation.remindForWaitingApplications'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <span class="radio">
                                            <label class="halves">
                                                <form:radiobutton
                                                    id="absenceSettings.remindForWaitingApplications.true"
                                                    path="absenceSettings.remindForWaitingApplications"
                                                    value="true"
                                                />
                                                <spring:message code="settings.vacation.remindForWaitingApplications.true"/>
                                            </label>
                                            <label class="halves">
                                                <form:radiobutton
                                                    id="absenceSettings.remindForWaitingApplications.false"
                                                    path="absenceSettings.remindForWaitingApplications"
                                                    value="false"
                                                />
                                                <spring:message code="settings.vacation.remindForWaitingApplications.false"/>
                                            </label>
                                        </span>
                                    </jsp:attribute>
                                </uv:form-group>
                                <uv:form-group required="true">
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="absenceSettings.daysBeforeRemindForWaitingApplications">
                                            <spring:message code='settings.vacation.daysBeforeRemindForWaitingApplications'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input-number
                                            id="absenceSettings.daysBeforeRemindForWaitingApplications"
                                            path="absenceSettings.daysBeforeRemindForWaitingApplications"
                                            step="1"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="absenceSettings.daysBeforeRemindForWaitingApplications" />
                                    </jsp:attribute>
                                </uv:form-group>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <uv:section-heading>
                            <h2>
                                <spring:message code="settings.sickDays.title"/>
                            </h2>
                        </uv:section-heading>
                        <div class="row">
                            <div class="col-md-4 col-md-push-8">
                                <span class="help-block tw-text-sm">
                                    <uv:icon-information-circle className="tw-w-4 tw-h-4" solid="true" />
                                    <spring:message code="settings.sickDays.description"/>
                                </span>
                            </div>
                            <div class="col-md-8 col-md-pull-4">
                                <uv:form-group required="true">
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="absenceSettings.maximumSickPayDays">
                                            <spring:message code='settings.sickDays.maximumSickPayDays'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input-number
                                            id="absenceSettings.maximumSickPayDays"
                                            path="absenceSettings.maximumSickPayDays"
                                            step="1"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="absenceSettings.maximumSickPayDays" />
                                    </jsp:attribute>
                                </uv:form-group>
                                <uv:form-group required="true">
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="absenceSettings.daysBeforeEndOfSickPayNotification">
                                            <spring:message code='settings.sickDays.daysBeforeEndOfSickPayNotification'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input-number
                                            id="absenceSettings.daysBeforeEndOfSickPayNotification"
                                            path="absenceSettings.daysBeforeEndOfSickPayNotification"
                                            step="1"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="absenceSettings.daysBeforeEndOfSickPayNotification" />
                                    </jsp:attribute>
                                </uv:form-group>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-pane" id="publicHolidays">
                    <div class="form-section">
                        <uv:section-heading>
                            <h2>
                                <spring:message code="settings.publicHolidays.title"/>
                            </h2>
                        </uv:section-heading>
                        <div class="row">
                            <div class="col-md-4 col-md-push-8">
                                <span class="help-block tw-text-sm">
                                    <uv:icon-information-circle className="tw-w-4 tw-h-4" solid="true" />
                                    <spring:message code="settings.publicHolidays.description"/>
                                </span>
                            </div>
                            <div class="col-md-8 col-md-pull-4">
                                <uv:form-group required="true">
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="workingTimeSettings.workingDurationForChristmasEve">
                                            <spring:message code='settings.publicHolidays.workingDuration.christmasEve'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <form:select
                                            path="workingTimeSettings.workingDurationForChristmasEve"
                                            id="dayLengthTypesChristmasEve"
                                            class="form-control"
                                            cssErrorClass="form-control error"
                                        >
                                            <c:forEach items="${dayLengthTypes}" var="dayLengthType">
                                                <form:option value="${dayLengthType}">
                                                    <spring:message code="${dayLengthType}"/>
                                                </form:option>
                                            </c:forEach>
                                        </form:select>
                                    </jsp:attribute>
                                </uv:form-group>
                                <uv:form-group required="true">
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="workingTimeSettings.workingDurationForNewYearsEve">
                                            <spring:message code='settings.publicHolidays.workingDuration.newYearsEve'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <form:select
                                            path="workingTimeSettings.workingDurationForNewYearsEve"
                                            id="dayLengthTypesNewYearsEve"
                                            class="form-control"
                                            cssErrorClass="form-control error"
                                        >
                                            <c:forEach items="${dayLengthTypes}" var="dayLengthType">
                                                <form:option value="${dayLengthType}">
                                                    <spring:message code="${dayLengthType}"/>
                                                </form:option>
                                            </c:forEach>
                                        </form:select>
                                    </jsp:attribute>
                                </uv:form-group>
                                <uv:form-group required="true">
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="federalStateType">
                                            <spring:message code='settings.publicHolidays.federalState'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <form:select
                                            path="workingTimeSettings.federalState"
                                            id="federalStateType"
                                            class="form-control"
                                            cssErrorClass="form-control error"
                                        >
                                            <c:forEach items="${federalStateTypes}" var="federalStateType">
                                                <form:option value="${federalStateType}">
                                                    <spring:message code="federalState.${federalStateType}"/>
                                                </form:option>
                                            </c:forEach>
                                        </form:select>
                                    </jsp:attribute>
                                </uv:form-group>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <uv:section-heading>
                            <h2>
                                <spring:message code="settings.overtime.title"/>
                            </h2>
                        </uv:section-heading>
                        <div class="row">
                            <div class="col-md-4 col-md-push-8">
                                <span class="help-block tw-text-sm">
                                    <uv:icon-information-circle className="tw-w-4 tw-h-4" solid="true" />
                                    <spring:message code="settings.overtime.description"/>
                                </span>
                            </div>
                            <div class="col-md-8 col-md-pull-4">

                                <uv:form-group required="true">
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="workingTimeSettings.overtimeActive.true">
                                            <spring:message code='settings.overtime.overtimeActive'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <span class="radio">
                                            <label class="halves">
                                                <form:radiobutton id="workingTimeSettings.overtimeActive.true"
                                                                  path="workingTimeSettings.overtimeActive" value="true"/>
                                                <spring:message code="settings.overtime.overtimeActive.true"/>
                                            </label>
                                            <label class="halves">
                                                <form:radiobutton id="workingTimeSettings.overtimeActive.false"
                                                                  path="workingTimeSettings.overtimeActive" value="false"/>
                                                <spring:message code="settings.overtime.overtimeActive.false"/>
                                            </label>
                                        </span>
                                    </jsp:attribute>
                                </uv:form-group>

                                <uv:form-group required="true">
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="workingTimeSettings.maximumOvertime">
                                            <spring:message code="settings.overtime.maximum"/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input-number
                                            id="workingTimeSettings.maximumOvertime"
                                            path="workingTimeSettings.maximumOvertime"
                                            step="1"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="workingTimeSettings.maximumOvertime" />
                                    </jsp:attribute>
                                </uv:form-group>

                                <uv:form-group required="true">
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="workingTimeSettings.minimumOvertime">
                                            <spring:message code="settings.overtime.minimum"/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input-number
                                            id="workingTimeSettings.minimumOvertime"
                                            path="workingTimeSettings.minimumOvertime"
                                            step="1"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="workingTimeSettings.minimumOvertime" />
                                    </jsp:attribute>
                                </uv:form-group>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-pane" id="calendar">

                    <div class="alert alert-danger tw-flex tw-items-center" role="alert">
                        <uv:icon-speakerphone className="tw-w-4 tw-h-4" solid="true" />
                        &nbsp;<spring:message code="settings.calendar.deprecated"/>
                    </div>

                    <div class="form-section">
                        <uv:section-heading>
                            <h2>
                                <spring:message code="settings.calendar.title"/>
                            </h2>
                        </uv:section-heading>
                        <div class="row">
                            <div class="col-md-4 col-md-push-8">
                                <span class="help-block tw-text-sm">
                                    <uv:icon-information-circle className="tw-w-4 tw-h-4" solid="true" />
                                    <spring:message code="settings.calendar.description"/>
                                </span>
                            </div>
                            <div class="col-md-8 col-md-pull-4">
                                <uv:form-group required="true">
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="calendarSettings.workDayBeginHour">
                                            <spring:message code='settings.calendar.workDay.begin'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input-number
                                            id="calendarSettings.workDayBeginHour"
                                            path="calendarSettings.workDayBeginHour"
                                            step="1"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="calendarSettings.workDayBeginHour" />
                                    </jsp:attribute>
                                </uv:form-group>
                                <uv:form-group required="true">
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="calendarSettings.workDayEndHour">
                                            <spring:message code='settings.calendar.workDay.end'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input-number
                                            id="calendarSettings.workDayEndHour"
                                            path="calendarSettings.workDayEndHour"
                                            step="1"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="calendarSettings.workDayEndHour" />
                                    </jsp:attribute>
                                </uv:form-group>
                                <uv:form-group required="true">
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="calendarSettingsProvider">
                                            <spring:message code='settings.calendar.provider'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <form:select
                                            id="calendarSettingsProvider"
                                            path="calendarSettings.provider"
                                            class="form-control"
                                            cssErrorClass="form-control error"
                                        >
                                            <c:forEach items="${providers}" var="provider">
                                                <form:option value="${provider}">
                                                    <spring:message code="settings.calendar.provider.${provider}"/>
                                                </form:option>
                                            </c:forEach>
                                        </form:select>
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="calendarSettings.provider" />
                                    </jsp:attribute>
                                </uv:form-group>
                            </div>
                        </div>
                    </div>

                    <div class="form-section" id="exchange-calendar">
                        <uv:section-heading>
                            <h2>
                                <spring:message code="settings.calendar.ews.title"/>
                            </h2>
                        </uv:section-heading>
                        <div class="row">
                            <div class="col-md-4 col-md-push-8">
                                <span class="help-block tw-text-sm">
                                    <uv:icon-information-circle className="tw-w-4 tw-h-4" solid="true" />
                                    <spring:message code="settings.calendar.ews.description"/>
                                </span>
                            </div>
                            <div class="col-md-8 col-md-pull-4">
                                <uv:form-group>
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="calendarSettings.exchangeCalendarSettings.email">
                                            <spring:message code='settings.calendar.ews.email'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input
                                            id="calendarSettings.exchangeCalendarSettings.email"
                                            path="calendarSettings.exchangeCalendarSettings.email"
                                            type="email"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="calendarSettings.exchangeCalendarSettings.email" />
                                    </jsp:attribute>
                                </uv:form-group>
                                <uv:form-group>
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="calendarSettings.exchangeCalendarSettings.password">
                                            <spring:message code='settings.calendar.ews.password'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <form:password
                                            showPassword="true"
                                            id="calendarSettings.exchangeCalendarSettings.password"
                                            path="calendarSettings.exchangeCalendarSettings.password"
                                            class="form-control"
                                            cssErrorClass="form-control error"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="calendarSettings.exchangeCalendarSettings.password" />
                                    </jsp:attribute>
                                </uv:form-group>
                                <uv:form-group>
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="calendarSettings.exchangeCalendarSettings.ewsUrl">
                                            <spring:message code='settings.calendar.ews.url'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input
                                            id="calendarSettings.exchangeCalendarSettings.ewsUrl"
                                            path="calendarSettings.exchangeCalendarSettings.ewsUrl"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="calendarSettings.exchangeCalendarSettings.ewsUrl" />
                                    </jsp:attribute>
                                </uv:form-group>
                                <uv:form-group>
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="calendarSettings.exchangeCalendarSettings.calendar">
                                            <spring:message code='settings.calendar.ews.calendar'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input
                                            id="calendarSettings.exchangeCalendarSettings.calendar"
                                            path="calendarSettings.exchangeCalendarSettings.calendar"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="calendarSettings.exchangeCalendarSettings.calendar" />
                                    </jsp:attribute>
                                </uv:form-group>
                                <uv:form-group>
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="calendarSettings.exchangeCalendarSettings.timeZoneId">
                                            <spring:message code='settings.calendar.ews.timeZoneId'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <form:select
                                            id="calendarSettings.exchangeCalendarSettings.timeZoneId"
                                            path="calendarSettings.exchangeCalendarSettings.timeZoneId"
                                            class="form-control chosenCombo"
                                            cssErrorClass="form-control error"
                                        >
                                            <c:forEach items="${availableTimezones}" var="timeZoneId">
                                                <form:option value="${timeZoneId}">
                                                    ${timeZoneId}
                                                </form:option>
                                            </c:forEach>
                                        </form:select>
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="calendarSettings.provider" />
                                    </jsp:attribute>
                                </uv:form-group>
                                <uv:form-group>
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="calendarSettings.exchangeCalendarSettings.sendInvitationActive">
                                            <spring:message code='settings.calendar.ews.notification'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <span class="checkbox">
                                            <label>
                                                <form:checkbox
                                                    id="calendarSettings.exchangeCalendarSettings.sendInvitationActive"
                                                    path="calendarSettings.exchangeCalendarSettings.sendInvitationActive"
                                                    value="true"
                                                />
                                                <spring:message code="settings.calendar.ews.notification.true"/>
                                            </label>
                                        </span>
                                    </jsp:attribute>
                                </uv:form-group>
                            </div>
                        </div>
                    </div>

                    <div class="form-section" id="google-calendar">
                        <div class="row">
                            <div class="col-xs-12">
                                <h2><spring:message code="settings.calendar.google.title"/></h2>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4 col-md-push-8">
                                <span class="help-block tw-text-sm">
                                    <uv:icon-information-circle className="tw-w-4 tw-h-4" solid="true" />
                                    <spring:message code="settings.calendar.google.description"/>
                                </span>
                            </div>
                            <div class="col-md-8 col-md-pull-4">
                                <uv:form-group>
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="calendarSettings.googleCalendarSettings.clientId">
                                            <spring:message code='settings.calendar.google.clientid'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input
                                            id="calendarSettings.googleCalendarSettings.clientId"
                                            path="calendarSettings.googleCalendarSettings.clientId"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="calendarSettings.googleCalendarSettings.clientId" />
                                    </jsp:attribute>
                                </uv:form-group>
                                <uv:form-group>
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="calendarSettings.googleCalendarSettings.clientSecret">
                                            <spring:message code='settings.calendar.google.clientsecret'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input
                                            id="calendarSettings.googleCalendarSettings.clientSecret"
                                            path="calendarSettings.googleCalendarSettings.clientSecret"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="calendarSettings.googleCalendarSettings.clientSecret" />
                                    </jsp:attribute>
                                </uv:form-group>
                                <uv:form-group>
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="calendarSettings.googleCalendarSettings.calendarId">
                                            <spring:message code='settings.calendar.google.calendarid'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input
                                            id="calendarSettings.googleCalendarSettings.calendarId"
                                            path="calendarSettings.googleCalendarSettings.calendarId"
                                        />
                                    </jsp:attribute>
                                    <jsp:attribute name="error">
                                        <form:errors path="calendarSettings.googleCalendarSettings.calendarId" />
                                    </jsp:attribute>
                                </uv:form-group>
                                <uv:form-group>
                                    <jsp:attribute name="label">
                                        <uv:form-label htmlFor="">
                                            <spring:message code='settings.calendar.google.redirecturl'/>:
                                        </uv:form-label>
                                    </jsp:attribute>
                                    <jsp:attribute name="input">
                                        <uv:form-input
                                            id="calendarSettings.googleCalendarSettings.authorizedRedirectUrl"
                                            path="calendarSettings.googleCalendarSettings.authorizedRedirectUrl"
                                            value="${authorizedRedirectUrl}"
                                            readonly="true"
                                        />
                                    </jsp:attribute>
                                </uv:form-group>
                                <div class="form-group">
                                    <c:if test="${not empty oautherrors}">
                                        <p class="text-danger col-md-8 col-md-push-4">
                                            ${oautherrors}
                                        </p>
                                    </c:if>
                                    <c:choose>
                                        <c:when
                                            test="${settings.calendarSettings.googleCalendarSettings.refreshToken == null}">
                                            <p class="text-danger col-md-5 col-md-push-4">
                                                <spring:message code="settings.calendar.google.action.authenticate.description"/>
                                            </p>
                                            <button id="googleOAuthButton" value="oauth" name="googleOAuthButton"
                                                    type="submit" class="btn btn-primary col-md-3 col-md-push-4">
                                                <spring:message code='settings.calendar.google.action.authenticate'/>
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-success col-md-8 col-md-push-4">
                                                <spring:message code="settings.calendar.google.action.authenticate.success"/>
                                            </p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <div class="row tw-mb-16">
                    <div class="col-xs-12">
                        <p class="help-block tw-text-sm"><spring:message code="settings.action.update.description"/></p>
                        <button type="submit" class="btn btn-success pull-left col-xs-12 col-sm-5 col-md-2">
                            <spring:message code='action.save'/>
                        </button>
                    </div>
                </div>
            </div>
        </form:form>
    </div>
</div>

</body>

</html>
