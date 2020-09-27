<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="uv" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@attribute name="id" type="java.lang.String" required="true" %>
<%@attribute name="path" type="java.lang.String" required="true" %>
<%@attribute name="value" type="java.lang.Number" required="false" %>
<%@attribute name="step" type="java.lang.String" required="false" %>

<c:set var="step" value="${step == null ? '1' : step}" />

<uv:input-number
    id="${id}"
    path="${path}"
    cssClass="form-control"
    cssErrorClass="form-control error"
    step="${step}"
    value="${value}"
/>

