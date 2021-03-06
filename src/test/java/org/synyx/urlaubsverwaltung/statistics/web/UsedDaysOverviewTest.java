package org.synyx.urlaubsverwaltung.statistics.web;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.synyx.urlaubsverwaltung.TestDataCreator;
import org.synyx.urlaubsverwaltung.application.domain.Application;
import org.synyx.urlaubsverwaltung.application.domain.ApplicationStatus;
import org.synyx.urlaubsverwaltung.application.domain.VacationCategory;
import org.synyx.urlaubsverwaltung.period.DayLength;
import org.synyx.urlaubsverwaltung.person.Person;
import org.synyx.urlaubsverwaltung.workingtime.WorkDaysCountService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

import static java.math.BigDecimal.ONE;
import static java.math.BigDecimal.ZERO;
import static java.util.Collections.singletonList;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatIllegalArgumentException;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.synyx.urlaubsverwaltung.TestDataCreator.createApplication;
import static org.synyx.urlaubsverwaltung.TestDataCreator.createVacationType;
import static org.synyx.urlaubsverwaltung.application.domain.VacationCategory.HOLIDAY;


@ExtendWith(MockitoExtension.class)
class UsedDaysOverviewTest {

    @Mock
    private WorkDaysCountService workDaysCountService;

    @Test
    void ensureThrowsIfOneOfTheGivenApplicationsDoesNotMatchTheGivenYear() {

        final Application application = new Application();
        application.setVacationType(createVacationType(HOLIDAY));
        application.setStartDate(LocalDate.of(2014, 10, 13));
        application.setEndDate(LocalDate.of(2014, 10, 13));
        application.setStatus(ApplicationStatus.WAITING);

        assertThatIllegalArgumentException()
            .isThrownBy(() -> new UsedDaysOverview(singletonList(application), 2015, workDaysCountService));
    }


    @Test
    void ensureGeneratesCorrectUsedDaysOverview() {

        final Application holiday = TestDataCreator.anyApplication();
        holiday.setVacationType(createVacationType(HOLIDAY));
        holiday.setStartDate(LocalDate.of(2014, 10, 13));
        holiday.setEndDate(LocalDate.of(2014, 10, 13));
        holiday.setStatus(ApplicationStatus.WAITING);

        final Application holidayAllowed = TestDataCreator.anyApplication();
        holidayAllowed.setVacationType(createVacationType(HOLIDAY));
        holidayAllowed.setStartDate(LocalDate.of(2014, 10, 14));
        holidayAllowed.setEndDate(LocalDate.of(2014, 10, 14));
        holidayAllowed.setStatus(ApplicationStatus.ALLOWED);

        final Application specialLeave = TestDataCreator.anyApplication();
        specialLeave.setVacationType(createVacationType(VacationCategory.SPECIALLEAVE));
        specialLeave.setStartDate(LocalDate.of(2014, 10, 15));
        specialLeave.setEndDate(LocalDate.of(2014, 10, 15));
        specialLeave.setStatus(ApplicationStatus.WAITING);

        final Application specialLeaveAllowed = TestDataCreator.anyApplication();
        specialLeaveAllowed.setVacationType(createVacationType(VacationCategory.SPECIALLEAVE));
        specialLeaveAllowed.setStartDate(LocalDate.of(2014, 10, 16));
        specialLeaveAllowed.setEndDate(LocalDate.of(2014, 10, 16));
        specialLeaveAllowed.setStatus(ApplicationStatus.ALLOWED);

        final Application unpaidLeave = TestDataCreator.anyApplication();
        unpaidLeave.setVacationType(createVacationType(VacationCategory.UNPAIDLEAVE));
        unpaidLeave.setStartDate(LocalDate.of(2014, 10, 17));
        unpaidLeave.setEndDate(LocalDate.of(2014, 10, 17));
        unpaidLeave.setStatus(ApplicationStatus.WAITING);

        final Application unpaidLeaveAllowed = TestDataCreator.anyApplication();
        unpaidLeaveAllowed.setVacationType(createVacationType(VacationCategory.UNPAIDLEAVE));
        unpaidLeaveAllowed.setStartDate(LocalDate.of(2014, 10, 20));
        unpaidLeaveAllowed.setEndDate(LocalDate.of(2014, 10, 20));
        unpaidLeaveAllowed.setStatus(ApplicationStatus.ALLOWED);

        final Application overtimeLeave = TestDataCreator.anyApplication();
        overtimeLeave.setVacationType(createVacationType(VacationCategory.OVERTIME));
        overtimeLeave.setStartDate(LocalDate.of(2014, 10, 21));
        overtimeLeave.setEndDate(LocalDate.of(2014, 10, 21));
        overtimeLeave.setStatus(ApplicationStatus.WAITING);

        final Application overtimeLeaveAllowed = TestDataCreator.anyApplication();
        overtimeLeaveAllowed.setVacationType(createVacationType(VacationCategory.OVERTIME));
        overtimeLeaveAllowed.setStartDate(LocalDate.of(2014, 10, 22));
        overtimeLeaveAllowed.setEndDate(LocalDate.of(2014, 10, 22));
        overtimeLeaveAllowed.setStatus(ApplicationStatus.ALLOWED);

        final List<Application> applications = Arrays.asList(holiday, holidayAllowed, specialLeave, specialLeaveAllowed,
            unpaidLeave, unpaidLeaveAllowed, overtimeLeave, overtimeLeaveAllowed);

        // just return 1 day for each application for leave
        when(workDaysCountService.getWorkDaysCount(any(DayLength.class), any(LocalDate.class),
            any(LocalDate.class), any(Person.class)))
            .thenReturn(ONE);

        final UsedDaysOverview usedDaysOverview = new UsedDaysOverview(applications, 2014, workDaysCountService);

        final UsedDays holidayDays = usedDaysOverview.getHolidayDays();
        assertThat(holidayDays.getDays())
            .containsEntry("WAITING", ONE)
            .containsEntry("ALLOWED", ONE);

        final UsedDays otherDays = usedDaysOverview.getOtherDays();
        assertThat(otherDays.getDays())
            .containsEntry("WAITING", BigDecimal.valueOf(3))
            .containsEntry("ALLOWED", BigDecimal.valueOf(3));
    }

    @Test
    void ensureCalculatesDaysForGivenYearForApplicationsSpanningTwoYears() {

        Person person = new Person("muster", "Muster", "Marlene", "muster@example.org");
        LocalDate startDate = LocalDate.of(2013, 12, 24);
        LocalDate endDate = LocalDate.of(2014, 1, 6);

        // 3 days in 2013, 2 days in 2014
        Application holiday = createApplication(person, createVacationType(HOLIDAY), startDate, endDate, DayLength.FULL);

        when(workDaysCountService.getWorkDaysCount(DayLength.FULL, LocalDate.of(2014, 1, 1), endDate, person))
            .thenReturn(BigDecimal.valueOf(2));

        final UsedDaysOverview usedDaysOverview = new UsedDaysOverview(singletonList(holiday), 2014, workDaysCountService);

        final UsedDays holidayDays = usedDaysOverview.getHolidayDays();
        assertThat(holidayDays.getDays())
            .containsEntry("WAITING", BigDecimal.valueOf(2))
            .containsEntry("ALLOWED", ZERO);

        final UsedDays otherDays = usedDaysOverview.getOtherDays();
        assertThat(otherDays.getDays())
            .containsEntry("WAITING", ZERO)
            .containsEntry("ALLOWED", ZERO);
    }

    @Test
    void ensureGeneratesCorrectUsedDaysOverviewConsideringTemporaryAllowedApplicationsForLeave() {

        final Application holiday = TestDataCreator.anyApplication();
        holiday.setVacationType(createVacationType(HOLIDAY));
        holiday.setStartDate(LocalDate.of(2014, 10, 13));
        holiday.setEndDate(LocalDate.of(2014, 10, 13));
        holiday.setStatus(ApplicationStatus.WAITING);

        final Application holidayAllowed = TestDataCreator.anyApplication();
        holidayAllowed.setVacationType(createVacationType(HOLIDAY));
        holidayAllowed.setStartDate(LocalDate.of(2014, 10, 14));
        holidayAllowed.setEndDate(LocalDate.of(2014, 10, 14));
        holidayAllowed.setStatus(ApplicationStatus.ALLOWED);

        final Application holidayTemporaryAllowed = TestDataCreator.anyApplication();
        holidayTemporaryAllowed.setVacationType(createVacationType(HOLIDAY));
        holidayTemporaryAllowed.setStartDate(LocalDate.of(2014, 10, 15));
        holidayTemporaryAllowed.setEndDate(LocalDate.of(2014, 10, 15));
        holidayTemporaryAllowed.setStatus(ApplicationStatus.TEMPORARY_ALLOWED);

        List<Application> applications = Arrays.asList(holiday, holidayTemporaryAllowed, holidayAllowed);

        // just return 1 day for each application for leave
        when(workDaysCountService.getWorkDaysCount(any(DayLength.class), any(LocalDate.class),
            any(LocalDate.class), any(Person.class))).thenReturn(ONE);

        final UsedDaysOverview usedDaysOverview = new UsedDaysOverview(applications, 2014, workDaysCountService);
        assertThat(usedDaysOverview.getHolidayDays().getDays())
            .containsEntry("WAITING", ONE)
            .containsEntry("TEMPORARY_ALLOWED", ONE)
            .containsEntry("ALLOWED", ONE);
    }
}
