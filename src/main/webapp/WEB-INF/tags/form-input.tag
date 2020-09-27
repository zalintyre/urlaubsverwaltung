<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%@attribute name="id" type="java.lang.String" required="true" %>
<%@attribute name="path" type="java.lang.String" required="true" %>
<%@attribute name="value" type="java.lang.String" required="false" %>
<%@attribute name="type" type="java.lang.String" required="false" %>
<%@attribute name="placeholder" type="java.lang.String" required="false" %>
<%@attribute name="autocomplete" type="java.lang.String" required="false" %>
<%@attribute name="readonly" type="java.lang.Boolean" required="false" %>

<c:set var="type" value="${type == null ? 'text' : type}" />
<c:set var="autocomplete" value="${autocomplete == null ? 'on' : autocomplete}" />
<c:set var="readonly" value="${readonly == null ? false : readonly}" />

<form:input
    type="type"
    id="${id}"
    path="${path}"
    class="form-control"
    cssErrorClass="form-control error"
    placeholder="${placeholder}"
    autocomplete="${autocomplete}"
    value="${value}"
    readonly="${readonly}"
/>

