package org.synyx.urlaubsverwaltung.statistics.web;

import liquibase.util.csv.CSVWriter;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.synyx.urlaubsverwaltung.application.domain.VacationType;
import org.synyx.urlaubsverwaltung.application.service.VacationTypeService;
import org.synyx.urlaubsverwaltung.statistics.ApplicationForLeaveStatistics;
import org.synyx.urlaubsverwaltung.web.FilterPeriod;

import java.util.Collections;
import java.util.List;

import static org.hamcrest.beans.SamePropertyValuesAs.samePropertyValuesAs;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.refEq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

@ExtendWith(MockitoExtension.class)
class ApplicationForLeaveStatisticsViewControllerTest {

    private ApplicationForLeaveStatisticsViewController sut;

    @Mock
    private ApplicationForLeaveStatisticsService applicationForLeaveStatisticsService;

    @Mock
    private ApplicationForLeaveStatisticsCsvExportService applicationForLeaveStatisticsCsvExportService;

    @Mock
    private VacationTypeService vacationTypeService;

    private FilterPeriod period;

    @BeforeEach
    void setUp() {

        final String startDate = "01.01.2019";
        final String endDate = "01.08.2019";

        period = new FilterPeriod(startDate, endDate);

        sut = new ApplicationForLeaveStatisticsViewController(applicationForLeaveStatisticsService, applicationForLeaveStatisticsCsvExportService, vacationTypeService);
    }

    @Test
    void applicationForLeaveStatisticsRedirectsToStatistics() throws Exception {

        final String expectedRedirect = "/web/application/statistics?from=" + period.getStartDateAsString() +
            "&to=" + period.getEndDateAsString();

        perform(post("/web/application/statistics")
            .flashAttr("period", period))
            .andExpect(status().isFound())
            .andExpect(redirectedUrl(expectedRedirect));
    }

    @Test
    void applicationForLeaveStatisticsAddsErrorToModelAndShowsFormIfPeriodNotTheSameYear() throws Exception {

        perform(get("/web/application/statistics")
            .param("from", "01.01.2019")
            .param("to", "01.08.2020"))
            .andExpect(model().attribute("errors", "INVALID_PERIOD"))
            .andExpect(view().name("application/app_statistics"));
    }

    @Test
    void applicationForLeaveStatisticsSetsModelAndView() throws Exception {

        final List<ApplicationForLeaveStatistics> statistics = Collections.emptyList();
        when(applicationForLeaveStatisticsService.getStatistics(any(FilterPeriod.class))).thenReturn(statistics);

        final List<VacationType> vacationType = Collections.singletonList(new VacationType());
        when(vacationTypeService.getVacationTypes()).thenReturn(vacationType);

        perform(get("/web/application/statistics")
            .param("from", period.getStartDateAsString())
            .param("to", period.getEndDateAsString()))
            .andExpect(model().attribute("from", period.getStartDate()))
            .andExpect(model().attribute("to", period.getEndDate()))
            .andExpect(model().attribute("statistics", statistics))
            .andExpect(model().attribute("period", samePropertyValuesAs(period)))
            .andExpect(model().attribute("vacationTypes", vacationType))
            .andExpect(view().name("application/app_statistics"));
    }

    @Test
    void downloadCSVAddsErrorToModelAndShowsFormIfPeriodNotTheSameYear() throws Exception {

        perform(get("/web/application/statistics/download")
            .param("from", "01.01.2000")
            .param("to", "01.01.2019"))
            .andExpect(model().attribute("errors", "INVALID_PERIOD"))
            .andExpect(view().name("application/app_statistics"));
    }

    @Test
    void downloadCSVSetsDownloadHeaders() throws Exception {

        final String expectedFilename = "filename.csv";
        when(applicationForLeaveStatisticsCsvExportService.getFileName(any(FilterPeriod.class))).thenReturn(expectedFilename);

        perform(get("/web/application/statistics/download")
            .param("from", "01.01.2019")
            .param("to", "01.08.2019"))
            .andExpect(header().string("Content-disposition", "attachment;filename=" + expectedFilename));
    }

    @Test
    void downloadCSVWritesCSV() throws Exception {

        final List<ApplicationForLeaveStatistics> statistics = Collections.emptyList();
        when(applicationForLeaveStatisticsService.getStatistics(any(FilterPeriod.class))).thenReturn(statistics);

        perform(get("/web/application/statistics/download")
            .param("from", period.getStartDateAsString())
            .param("to", period.getEndDateAsString()));

        verify(applicationForLeaveStatisticsCsvExportService).writeStatistics(refEq(period), eq(statistics), any(CSVWriter.class));
    }

    @Test
    void downloadCSVSetsModelAndView() throws Exception {

        when(applicationForLeaveStatisticsService.getStatistics(any(FilterPeriod.class))).thenReturn(Collections.emptyList());

        perform(get("/web/application/statistics/download")
            .param("from", period.getStartDateAsString())
            .param("to", period.getEndDateAsString()))
            .andExpect(model().attribute("period", samePropertyValuesAs(period)))
            .andExpect(view().name("application/app_statistics"));
    }

    private ResultActions perform(MockHttpServletRequestBuilder builder) throws Exception {

        return standaloneSetup(sut).build().perform(builder);
    }

}
