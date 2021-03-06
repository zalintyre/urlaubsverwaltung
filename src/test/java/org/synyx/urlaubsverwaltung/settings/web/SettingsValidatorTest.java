package org.synyx.urlaubsverwaltung.settings.web;

import org.junit.Assert;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.validation.Errors;
import org.synyx.urlaubsverwaltung.calendarintegration.providers.exchange.ExchangeCalendarProvider;
import org.synyx.urlaubsverwaltung.calendarintegration.providers.google.GoogleCalendarSyncProvider;
import org.synyx.urlaubsverwaltung.settings.AbsenceSettings;
import org.synyx.urlaubsverwaltung.settings.CalendarSettings;
import org.synyx.urlaubsverwaltung.settings.ExchangeCalendarSettings;
import org.synyx.urlaubsverwaltung.settings.GoogleCalendarSettings;
import org.synyx.urlaubsverwaltung.settings.Settings;
import org.synyx.urlaubsverwaltung.settings.TimeSettings;
import org.synyx.urlaubsverwaltung.settings.WorkingTimeSettings;

import static org.assertj.core.api.Assertions.assertThatIllegalArgumentException;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;


class SettingsValidatorTest {

    private SettingsValidator settingsValidator;

    @BeforeEach
    void setUp() {

        settingsValidator = new SettingsValidator();
    }


    // Supported class -------------------------------------------------------------------------------------------------

    @Test
    void ensureSettingsClassIsSupported() {

        Assert.assertTrue("Should return true for Settings class.", settingsValidator.supports(Settings.class));
    }


    @Test
    void ensureOtherClassThanSettingsIsNotSupported() {

        Assert.assertFalse("Should return false for other classes than Settings.",
            settingsValidator.supports(Object.class));
    }


    @Test
    void ensureThatValidateFailsWithOtherClassThanSettings() {
        assertThatIllegalArgumentException().isThrownBy(() -> settingsValidator.validate(new Object(), mock(Errors.class)));
    }


    // Working time settings: Public holidays --------------------------------------------------------------------------

    @Test
    void ensureWorkingTimeSettingsCanNotBeNull() {

        Settings settings = new Settings();
        WorkingTimeSettings workingTimeSettings = settings.getWorkingTimeSettings();
        workingTimeSettings.setFederalState(null);
        workingTimeSettings.setWorkingDurationForChristmasEve(null);
        workingTimeSettings.setWorkingDurationForNewYearsEve(null);
        workingTimeSettings.setMaximumOvertime(null);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);
        verify(mockError).rejectValue("workingTimeSettings.federalState", "error.entry.mandatory");
        verify(mockError)
            .rejectValue("workingTimeSettings.workingDurationForChristmasEve", "error.entry.mandatory");
        verify(mockError)
            .rejectValue("workingTimeSettings.workingDurationForNewYearsEve", "error.entry.mandatory");
    }


    // Working time settings: Overtime settings ------------------------------------------------------------------------

    @Test
    void ensureOvertimeSettingsAreMandatoryIfOvertimeManagementIsActive() {

        Settings settings = new Settings();
        WorkingTimeSettings workingTimeSettings = settings.getWorkingTimeSettings();
        workingTimeSettings.setOvertimeActive(true);
        workingTimeSettings.setMaximumOvertime(null);
        workingTimeSettings.setMinimumOvertime(null);

        Errors mockError = mock(Errors.class);

        settingsValidator.validate(settings, mockError);

        verify(mockError).rejectValue("workingTimeSettings.maximumOvertime", "error.entry.mandatory");
        verify(mockError).rejectValue("workingTimeSettings.minimumOvertime", "error.entry.mandatory");
    }


    @Test
    void ensureOvertimeSettingsAreNotMandatoryIfOvertimeManagementIsInactive() {

        Settings settings = new Settings();
        WorkingTimeSettings workingTimeSettings = settings.getWorkingTimeSettings();
        workingTimeSettings.setOvertimeActive(false);
        workingTimeSettings.setMaximumOvertime(null);
        workingTimeSettings.setMinimumOvertime(null);

        Errors mockError = mock(Errors.class);

        settingsValidator.validate(settings, mockError);

        verifyNoInteractions(mockError);
    }


    @Test
    void ensureMaximumOvertimeCanNotBeNegative() {

        Settings settings = new Settings();
        WorkingTimeSettings workingTimeSettings = settings.getWorkingTimeSettings();
        workingTimeSettings.setOvertimeActive(true);
        workingTimeSettings.setMaximumOvertime(-1);

        Errors mockError = mock(Errors.class);

        settingsValidator.validate(settings, mockError);

        verify(mockError).rejectValue("workingTimeSettings.maximumOvertime", "error.entry.invalid");
    }


    @Test
    void ensureMinimumOvertimeCanNotBeNegative() {

        Settings settings = new Settings();
        WorkingTimeSettings workingTimeSettings = settings.getWorkingTimeSettings();
        workingTimeSettings.setOvertimeActive(true);
        workingTimeSettings.setMinimumOvertime(-1);

        Errors mockError = mock(Errors.class);

        settingsValidator.validate(settings, mockError);

        verify(mockError).rejectValue("workingTimeSettings.minimumOvertime", "error.entry.invalid");
    }


    // Absence settings ------------------------------------------------------------------------------------------------

    @Test
    void ensureAbsenceSettingsCanNotBeNull() {

        Settings settings = new Settings();
        AbsenceSettings absenceSettings = settings.getAbsenceSettings();

        absenceSettings.setMaximumAnnualVacationDays(null);
        absenceSettings.setMaximumMonthsToApplyForLeaveInAdvance(null);
        absenceSettings.setMaximumSickPayDays(null);
        absenceSettings.setDaysBeforeEndOfSickPayNotification(null);
        absenceSettings.setDaysBeforeRemindForWaitingApplications(null);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);
        verify(mockError).rejectValue("absenceSettings.maximumAnnualVacationDays", "error.entry.mandatory");
        verify(mockError)
            .rejectValue("absenceSettings.maximumMonthsToApplyForLeaveInAdvance", "error.entry.mandatory");
        verify(mockError).rejectValue("absenceSettings.maximumSickPayDays", "error.entry.mandatory");
        verify(mockError)
            .rejectValue("absenceSettings.daysBeforeEndOfSickPayNotification", "error.entry.mandatory");
        verify(mockError)
            .rejectValue("absenceSettings.daysBeforeRemindForWaitingApplications", "error.entry.mandatory");
    }


    @Test
    void ensureAbsenceSettingsCanNotBeNegative() {

        Settings settings = new Settings();
        AbsenceSettings absenceSettings = settings.getAbsenceSettings();

        absenceSettings.setMaximumAnnualVacationDays(-1);
        absenceSettings.setMaximumMonthsToApplyForLeaveInAdvance(-1);
        absenceSettings.setMaximumSickPayDays(-1);
        absenceSettings.setDaysBeforeEndOfSickPayNotification(-1);
        absenceSettings.setDaysBeforeRemindForWaitingApplications(-1);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);
        verify(mockError).rejectValue("absenceSettings.maximumAnnualVacationDays", "error.entry.invalid");
        verify(mockError)
            .rejectValue("absenceSettings.maximumMonthsToApplyForLeaveInAdvance", "error.entry.invalid");
        verify(mockError).rejectValue("absenceSettings.maximumSickPayDays", "error.entry.invalid");
        verify(mockError)
            .rejectValue("absenceSettings.daysBeforeEndOfSickPayNotification", "error.entry.invalid");
        verify(mockError)
            .rejectValue("absenceSettings.daysBeforeEndOfSickPayNotification", "error.entry.invalid");
    }


    @Test
    void ensureThatMaximumMonthsToApplyForLeaveInAdvanceNotZero() {

        Settings settings = new Settings();
        settings.getAbsenceSettings().setMaximumMonthsToApplyForLeaveInAdvance(0);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);
        verify(mockError)
            .rejectValue("absenceSettings.maximumMonthsToApplyForLeaveInAdvance", "error.entry.invalid");
    }


    @Test
    void ensureThatMaximumAnnualVacationDaysSmallerThanAYear() {

        Settings settings = new Settings();
        settings.getAbsenceSettings().setMaximumAnnualVacationDays(367);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);
        verify(mockError).rejectValue("absenceSettings.maximumAnnualVacationDays", "error.entry.invalid");
    }


    @Test
    void ensureThatAbsenceSettingsAreSmallerOrEqualsThanMaxInt() {

        Settings settings = new Settings();
        AbsenceSettings absenceSettings = settings.getAbsenceSettings();

        absenceSettings.setDaysBeforeEndOfSickPayNotification(Integer.MAX_VALUE + 1);
        absenceSettings.setMaximumAnnualVacationDays(Integer.MAX_VALUE + 1);
        absenceSettings.setMaximumMonthsToApplyForLeaveInAdvance(Integer.MAX_VALUE + 1);
        absenceSettings.setMaximumSickPayDays(Integer.MAX_VALUE + 1);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);
        verify(mockError)
            .rejectValue("absenceSettings.daysBeforeEndOfSickPayNotification", "error.entry.invalid");
        verify(mockError).rejectValue("absenceSettings.maximumAnnualVacationDays", "error.entry.invalid");
        verify(mockError)
            .rejectValue("absenceSettings.maximumMonthsToApplyForLeaveInAdvance", "error.entry.invalid");
        verify(mockError).rejectValue("absenceSettings.maximumSickPayDays", "error.entry.invalid");
    }


    @Test
    void ensureThatDaysBeforeEndOfSickPayNotificationIsSmallerThanMaximumSickPayDays() {

        Settings settings = new Settings();
        AbsenceSettings absenceSettings = settings.getAbsenceSettings();
        absenceSettings.setDaysBeforeEndOfSickPayNotification(11);
        absenceSettings.setMaximumSickPayDays(10);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);
        verify(mockError)
            .rejectValue("absenceSettings.daysBeforeEndOfSickPayNotification",
                "settings.sickDays.daysBeforeEndOfSickPayNotification.error");
    }


    // Time settings -----------------------------------------------------------------------------------------------

    @Test
    void ensureCalendarSettingsAreMandatory() {

        Settings settings = new Settings();
        TimeSettings timeSettings = settings.getTimeSettings();

        timeSettings.setWorkDayBeginHour(null);
        timeSettings.setWorkDayEndHour(null);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);
        verify(mockError).rejectValue("timeSettings.workDayBeginHour", "error.entry.mandatory");
        verify(mockError).rejectValue("timeSettings.workDayEndHour", "error.entry.mandatory");
    }


    @Test
    void ensureCalendarSettingsAreInvalidIfWorkDayBeginAndEndHoursAreSame() {

        Settings settings = new Settings();
        TimeSettings timeSettings = settings.getTimeSettings();

        timeSettings.setWorkDayBeginHour(8);
        timeSettings.setWorkDayEndHour(8);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);
        verify(mockError).rejectValue("timeSettings.workDayBeginHour", "error.entry.invalid");
        verify(mockError).rejectValue("timeSettings.workDayEndHour", "error.entry.invalid");
    }


    @Test
    void ensureCalendarSettingsAreInvalidIfWorkDayBeginHourIsGreaterThanEndHour() {

        Settings settings = new Settings();
        TimeSettings timeSettings = settings.getTimeSettings();

        timeSettings.setWorkDayBeginHour(17);
        timeSettings.setWorkDayEndHour(8);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);
        verify(mockError).rejectValue("timeSettings.workDayBeginHour", "error.entry.invalid");
        verify(mockError).rejectValue("timeSettings.workDayEndHour", "error.entry.invalid");
    }


    @Test
    void ensureCalendarSettingsAreInvalidIfWorkDayBeginOrEndHoursAreNegative() {

        Settings settings = new Settings();
        TimeSettings timeSettings = settings.getTimeSettings();

        timeSettings.setWorkDayBeginHour(-1);
        timeSettings.setWorkDayEndHour(-2);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);
        verify(mockError).rejectValue("timeSettings.workDayBeginHour", "error.entry.invalid");
        verify(mockError).rejectValue("timeSettings.workDayEndHour", "error.entry.invalid");
    }


    @Test
    void ensureCalendarSettingsAreInvalidIfWorkDayBeginOrEndHoursAreZero() {

        Settings settings = new Settings();
        TimeSettings timeSettings = settings.getTimeSettings();

        timeSettings.setWorkDayBeginHour(0);
        timeSettings.setWorkDayEndHour(0);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);
        verify(mockError).rejectValue("timeSettings.workDayBeginHour", "error.entry.invalid");
        verify(mockError).rejectValue("timeSettings.workDayEndHour", "error.entry.invalid");
    }


    @Test
    void ensureCalendarSettingsAreInvalidIfWorkDayBeginOrEndHoursAreGreaterThan24() {

        Settings settings = new Settings();
        TimeSettings timeSettings = settings.getTimeSettings();

        timeSettings.setWorkDayBeginHour(25);
        timeSettings.setWorkDayEndHour(42);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);
        verify(mockError).rejectValue("timeSettings.workDayBeginHour", "error.entry.invalid");
        verify(mockError).rejectValue("timeSettings.workDayEndHour", "error.entry.invalid");
    }

    @Test
    void ensureCalendarSettingsAreValidIfValidWorkDayBeginAndEndHours() {

        Settings settings = new Settings();
        TimeSettings timeSettings = settings.getTimeSettings();

        timeSettings.setWorkDayBeginHour(10);
        timeSettings.setWorkDayEndHour(18);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);

        verifyNoInteractions(mockError);
    }


    // Exchange calendar settings --------------------------------------------------------------------------------------

    @Test
    void ensureExchangeCalendarSettingsAreNotMandatoryIfDeactivated() {

        Settings settings = new Settings();
        ExchangeCalendarSettings exchangeCalendarSettings = settings.getCalendarSettings()
            .getExchangeCalendarSettings();

        exchangeCalendarSettings.setEmail(null);
        exchangeCalendarSettings.setPassword(null);
        exchangeCalendarSettings.setCalendar(null);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);

        verifyNoInteractions(mockError);
    }


    @Test
    void ensureExchangeCalendarSettingsAreMandatory() {

        Settings settings = new Settings();
        ExchangeCalendarSettings exchangeCalendarSettings = settings.getCalendarSettings()
            .getExchangeCalendarSettings();

        settings.getCalendarSettings().setProvider(ExchangeCalendarProvider.class.getSimpleName());
        exchangeCalendarSettings.setEmail(null);
        exchangeCalendarSettings.setPassword(null);
        exchangeCalendarSettings.setCalendar(null);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);

        verify(mockError)
            .rejectValue("calendarSettings.exchangeCalendarSettings.email", "error.entry.mandatory");
        verify(mockError)
            .rejectValue("calendarSettings.exchangeCalendarSettings.password", "error.entry.mandatory");
        verify(mockError)
            .rejectValue("calendarSettings.exchangeCalendarSettings.calendar", "error.entry.mandatory");
    }

    @Test
    void ensureExchangeCalendarEmailMustHaveValidFormat() {

        Settings settings = new Settings();
        ExchangeCalendarSettings exchangeCalendarSettings = settings.getCalendarSettings()
            .getExchangeCalendarSettings();

        settings.getCalendarSettings().setProvider(ExchangeCalendarProvider.class.getSimpleName());
        exchangeCalendarSettings.setEmail("synyx");
        exchangeCalendarSettings.setPassword("top-secret");
        exchangeCalendarSettings.setCalendar("Urlaub");

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);

        verify(mockError).rejectValue("calendarSettings.exchangeCalendarSettings.email", "error.entry.mail");
    }

    @Test
    void ensureGoogleCalendarSettingsAreMandatory() {

        Settings settings = new Settings();
        GoogleCalendarSettings googleCalendarSettings = settings.getCalendarSettings()
            .getGoogleCalendarSettings();

        settings.getCalendarSettings().setProvider(GoogleCalendarSyncProvider.class.getSimpleName());
        googleCalendarSettings.setCalendarId(null);
        googleCalendarSettings.setClientId(null);
        googleCalendarSettings.setClientSecret(null);

        Errors mockError = mock(Errors.class);
        settingsValidator.validate(settings, mockError);

        verify(mockError)
            .rejectValue("calendarSettings.googleCalendarSettings.calendarId", "error.entry.mandatory");
        verify(mockError)
            .rejectValue("calendarSettings.googleCalendarSettings.clientId", "error.entry.mandatory");
        verify(mockError)
            .rejectValue("calendarSettings.googleCalendarSettings.clientSecret", "error.entry.mandatory");
    }
}
