package org.synyx.urlaubsverwaltung.application.web;

import org.junit.Assert;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.synyx.urlaubsverwaltung.TestDataCreator;
import org.synyx.urlaubsverwaltung.application.domain.Application;
import org.synyx.urlaubsverwaltung.period.DayLength;
import org.synyx.urlaubsverwaltung.period.WeekDay;
import org.synyx.urlaubsverwaltung.person.Person;
import org.synyx.urlaubsverwaltung.workingtime.WorkDaysCountService;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;


class ApplicationForLeaveTest {

    private WorkDaysCountService workDaysCountService;

    @BeforeEach
    void setUp() {

        workDaysCountService = mock(WorkDaysCountService.class);
    }


    @Test
    void ensureCreatesCorrectApplicationForLeave() {

        Person person = new Person("muster", "Muster", "Marlene", "muster@example.org");

        Application application = TestDataCreator.createApplication(person, LocalDate.of(2015, 3, 3),
            LocalDate.of(2015, 3, 6), DayLength.FULL);

        when(workDaysCountService.getWorkDaysCount(any(DayLength.class), any(LocalDate.class),
            any(LocalDate.class), any(Person.class)))
            .thenReturn(BigDecimal.TEN);

        ApplicationForLeave applicationForLeave = new ApplicationForLeave(application, workDaysCountService);

        verify(workDaysCountService)
            .getWorkDaysCount(application.getDayLength(), application.getStartDate(), application.getEndDate(), person);

        Assert.assertNotNull("Should not be null", applicationForLeave.getStartDate());
        Assert.assertNotNull("Should not be null", applicationForLeave.getEndDate());
        Assert.assertNotNull("Should not be null", applicationForLeave.getDayLength());

        Assert.assertEquals("Wrong start date", application.getStartDate(), applicationForLeave.getStartDate());
        Assert.assertEquals("Wrong end date", application.getEndDate(), applicationForLeave.getEndDate());
        Assert.assertEquals("Wrong day length", application.getDayLength(), applicationForLeave.getDayLength());

        Assert.assertNotNull("Should not be null", applicationForLeave.getWorkDays());
        Assert.assertEquals("Wrong number of work days", BigDecimal.TEN, applicationForLeave.getWorkDays());
    }


    @Test
    void ensureApplicationForLeaveHasInformationAboutDayOfWeek() {

        Person person = new Person("muster", "Muster", "Marlene", "muster@example.org");

        Application application = TestDataCreator.createApplication(person, LocalDate.of(2016, 3, 1),
            LocalDate.of(2016, 3, 4), DayLength.FULL);

        when(workDaysCountService.getWorkDaysCount(any(DayLength.class), any(LocalDate.class),
            any(LocalDate.class), any(Person.class)))
            .thenReturn(BigDecimal.valueOf(4));

        ApplicationForLeave applicationForLeave = new ApplicationForLeave(application, workDaysCountService);

        Assert.assertNotNull("Missing day of week for start date", applicationForLeave.getWeekDayOfStartDate());
        Assert.assertEquals("Wrong day of week for start date", WeekDay.TUESDAY,
            applicationForLeave.getWeekDayOfStartDate());

        Assert.assertNotNull("Missing day of week for end date", applicationForLeave.getWeekDayOfEndDate());
        Assert.assertEquals("Wrong day of week for end date", WeekDay.FRIDAY,
            applicationForLeave.getWeekDayOfEndDate());
    }
}
