<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="uv" tagdir="/WEB-INF/tags" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@taglib prefix="asset" uri="/WEB-INF/asset.tld" %>

<sec:authorize access="hasAuthority('USER')">
    <c:set var="IS_USER" value="${true}"/>
</sec:authorize>

<sec:authorize access="hasAuthority('BOSS')">
    <c:set var="IS_BOSS" value="${true}"/>
</sec:authorize>

<sec:authorize access="hasAuthority('DEPARTMENT_HEAD')">
    <c:set var="IS_DEPARTMENT_HEAD" value="${true}"/>
</sec:authorize>

<sec:authorize access="hasAuthority('SECOND_STAGE_AUTHORITY')">
    <c:set var="IS_SECOND_STAGE_AUTHORITY" value="${true}"/>
</sec:authorize>

<sec:authorize access="hasAuthority('OFFICE')">
    <c:set var="IS_OFFICE" value="${true}"/>
</sec:authorize>

<c:set var="CAN_ALLOW" value="${IS_BOSS || IS_DEPARTMENT_HEAD || IS_SECOND_STAGE_AUTHORITY}"/>

<!DOCTYPE html>
<html lang="${language}">

<head>
    <title>
        <spring:message code="applications.header.title"/>
    </title>
    <uv:custom-head/>
    <script defer src="<asset:url value='app_list.js' />"></script>
</head>

<body>

<spring:url var="URL_PREFIX" value="/web"/>
<c:set var="linkPrefix" value="${URL_PREFIX}/application"/>

<uv:menu/>

<div class="content">
    <div class="container">

        <div class="row">
            <div class="col-xs-12">

                <legend>
                    <spring:message code="applications.waiting"/>

                    <a href="${URL_PREFIX}/application/statistics" class="fa-action pull-right"
                       data-title="<spring:message code="action.applications.statistics"/>">
                        <i class="fa fa-fw fa-bar-chart" aria-hidden="true"></i>
                    </a>
                    <a href="${URL_PREFIX}/application/vacationoverview" class="fa-action pull-right"
                       data-title="<spring:message code="action.applications.vacation_overview"/>">
                        <i class="fa fa-fw fa-calendar" aria-hidden="true"></i>
                    </a>
                    <sec:authorize access="hasAuthority('OFFICE')">
                        <a href="${URL_PREFIX}/application/new" class="fa-action pull-right"
                           data-title="<spring:message code="action.apply.vacation"/>">
                            <i class="fa fa-fw fa-plus-circle" aria-hidden="true"></i>
                        </a>
                    </sec:authorize>
                </legend>

                <div class="feedback">
                    <c:choose>
                        <c:when test="${allowSuccess}">
                            <div class="alert alert-success">
                                <spring:message code="application.action.allow.success"/>
                            </div>
                        </c:when>
                        <c:when test="${temporaryAllowSuccess}">
                            <div class="alert alert-success">
                                <spring:message code="application.action.temporary_allow.success"/>
                            </div>
                        </c:when>
                        <c:when test="${rejectSuccess}">
                            <div class="alert alert-success">
                                <spring:message code="application.action.reject.success"/>
                            </div>
                        </c:when>
                    </c:choose>
                </div>

                <c:choose>
                    <c:when test="${empty applications}">
                        <spring:message code="applications.none"/>
                    </c:when>

                    <c:otherwise>

                        <table class="list-table selectable-table">
                            <tbody>
                            <c:forEach items="${applications}" var="application" varStatus="loopStatus">
                                <tr class="active" onclick="navigate('${URL_PREFIX}/application/${application.id}');">
                                    <td class="hidden-print is-centered">
                                        <div class="gravatar img-circle"
                                             data-gravatar="<c:out value='${application.person.gravatarURL}?d=mm&s=60'/>"></div>
                                    </td>
                                    <td class="hidden-xs">
                                        <h5><c:out value="${application.person.niceName}"/></h5>
                                        <p><spring:message code="application.applier.applied"/></p>
                                    </td>
                                    <td class="halves">
                                        <a class="vacation ${application.vacationType.category} hidden-print"
                                           href="${URL_PREFIX}/application/${application.id}">
                                            <h4>
                                                <c:choose>
                                                    <c:when test="${application.hours != null}">
                                                        <uv:number number="${application.hours}"/>
                                                        <spring:message code="duration.hours"/>
                                                        <spring:message code="${application.vacationType.messageKey}"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <uv:number number="${application.workDays}"/>
                                                        <spring:message code="duration.days"/>
                                                        <spring:message code="${application.vacationType.messageKey}"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </h4>
                                        </a>
                                        <p>
                                            <c:choose>
                                                <c:when test="${application.startDate == application.endDate}">
                                                    <c:set var="APPLICATION_DATE">
                                                        <spring:message code="${application.weekDayOfStartDate}.short"/>,
                                                        <uv:date date="${application.startDate}"/>
                                                    </c:set>
                                                    <c:choose>
                                                        <c:when
                                                            test="${application.startTime != null && application.endTime != null}">
                                                            <c:set var="APPLICATION_START_TIME">
                                                                <uv:time dateTime="${application.startDateWithTime}"/>
                                                            </c:set>
                                                            <c:set var="APPLICATION_END_TIME">
                                                                <uv:time dateTime="${application.endDateWithTime}"/>
                                                            </c:set>
                                                            <c:set var="APPLICATION_TIME">
                                                                <spring:message code="absence.period.time"
                                                                                arguments="${APPLICATION_START_TIME};${APPLICATION_END_TIME}"
                                                                                argumentSeparator=";"/>
                                                            </c:set>
                                                            <spring:message code="absence.period.singleDay"
                                                                            arguments="${APPLICATION_DATE};${APPLICATION_TIME}"
                                                                            argumentSeparator=";"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="APPLICATION_DAY_LENGTH">
                                                                <spring:message code="${application.dayLength}"/>
                                                            </c:set>
                                                            <spring:message code="absence.period.singleDay"
                                                                            arguments="${APPLICATION_DATE};${APPLICATION_DAY_LENGTH}"
                                                                            argumentSeparator=";"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="APPLICATION_START_DATE">
                                                        <spring:message code="${application.weekDayOfStartDate}.short"/>,
                                                        <uv:date date="${application.startDate}"/>
                                                    </c:set>
                                                    <c:set var="APPLICATION_END_DATE">
                                                        <spring:message code="${application.weekDayOfEndDate}.short"/>,
                                                        <uv:date date="${application.endDate}"/>
                                                    </c:set>
                                                    <spring:message code="absence.period.multipleDays"
                                                                    arguments="${APPLICATION_START_DATE};${APPLICATION_END_DATE}"
                                                                    argumentSeparator=";"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </td>
                                    <td class="hidden-xs hidden-sm text-right">
                                        <c:if
                                            test="${CAN_ALLOW && (application.person.id != signedInUser.id || IS_BOSS)}">
                                            <a class="fa-action positive"
                                               href="${URL_PREFIX}/application/${application.id}?action=allow&shortcut=true"
                                               data-title="<spring:message code='action.allow'/>">
                                                <i class="fa fa-check" aria-hidden="true"></i>
                                            </a>
                                        </c:if>
                                        <c:if
                                            test="${CAN_ALLOW && (application.person.id != signedInUser.id || IS_BOSS)}">
                                            <a class="fa-action negative"
                                               href="${URL_PREFIX}/application/${application.id}?action=reject&shortcut=true"
                                               data-title="<spring:message code='action.reject'/>">
                                                <i class="fa fa-ban" aria-hidden="true"></i>
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>

                <legend>
                    <spring:message code="applications.cancellation_request"/>
                </legend>
                <c:choose>
                    <c:when test="${empty applications}">
                        <spring:message code="applications.none"/>
                    </c:when>

                    <c:otherwise>
                        <table class="list-table selectable-table">
                            <tbody>
                            <c:forEach items="${applications_cancellation_request}" var="application_la">
                                <tr class="active"
                                    onclick="navigate('${URL_PREFIX}/application/${application_la.id}');">
                                    <td class="hidden-print is-centered">
                                        <div class="gravatar img-circle"
                                             data-gravatar="<c:out value='${application_la.person.gravatarURL}?d=mm&s=60'/>"></div>
                                    </td>
                                    <td class="hidden-xs">
                                        <h5><c:out value="${application_la.person.niceName}"/></h5>
                                        <p><spring:message code="application.applier.cancellation_request"/></p>
                                    </td>
                                    <td class="hidden-xs hidden-sm text-right">
                                        <a class="fa-action positive"
                                           href="${URL_PREFIX}/application/${application_la.id}?action=cancel&shortcut=true"
                                           data-title="<spring:message code='action.delete'/>">
                                            <i class="fa fa-trash" aria-hidden="true"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>
</div>
</body>
</html>
