package org.synyx.urlaubsverwaltung.department;

import org.junit.Assert;
import org.junit.jupiter.api.Test;
import org.synyx.urlaubsverwaltung.person.Person;

import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;

import static java.time.ZoneOffset.UTC;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatIllegalArgumentException;


class DepartmentTest {

    @Test
    void ensureLastModificationDateIsSetAfterInitialization() {

        Department department = new Department();

        Assert.assertNotNull("Last modification date should be set", department.getLastModification());
        Assert.assertEquals("Wrong last modification date", LocalDate.now(UTC),
            department.getLastModification());
    }


    @Test
    void ensureCanNotSetLastModificationDateToNull() {
        assertThatIllegalArgumentException().isThrownBy(() -> new Department().setLastModification(null));
    }


    @Test
    void ensureReturnsCorrectLastModificationDate() {

        LocalDate lastModification = ZonedDateTime.now(UTC).minusDays(5).toLocalDate();

        Department department = new Department();
        department.setLastModification(lastModification);

        Assert.assertEquals("Wrong last modification date", lastModification, department.getLastModification());
    }


    @Test
    void ensureMembersListIsUnmodifiable() {

        List<Person> modifiableList = new ArrayList<>();
        modifiableList.add(new Person("muster", "Muster", "Marlene", "muster@example.org"));

        Department department = new Department();
        department.setMembers(modifiableList);

        try {
            department.getMembers().add(new Person("muster", "Muster", "Marlene", "muster@example.org"));
            Assert.fail("Members list should be unmodifiable!");
        } catch (UnsupportedOperationException ex) {
            // Expected
        }
    }


    @Test
    void ensureDepartmentHeadsListIsUnmodifiable() {

        List<Person> modifiableList = new ArrayList<>();
        modifiableList.add(new Person("muster", "Muster", "Marlene", "muster@example.org"));

        Department department = new Department();
        department.setDepartmentHeads(modifiableList);

        try {
            department.getDepartmentHeads().add(new Person("muster", "Muster", "Marlene", "muster@example.org"));
            Assert.fail("Department head list should be unmodifiable!");
        } catch (UnsupportedOperationException ex) {
            // Expected
        }
    }

    @Test
    void toStringTest() {
        final Department department = new Department();
        department.setId(1);
        department.setLastModification(LocalDate.MAX);
        department.setDescription("Description");
        department.setName("DepartmentName");
        department.setTwoStageApproval(true);
        department.setMembers(List.of(new Person("Member", "Theo", "Theo", "Theo")));
        department.setDepartmentHeads(List.of(new Person("Heads", "Theo", "Theo", "Theo")));
        department.setSecondStageAuthorities(List.of(new Person("Second", "Theo", "Theo", "Theo")));

        final String departmentToString = department.toString();
        assertThat(departmentToString).isEqualTo("Department{name='DepartmentName', description='Description', " +
            "lastModification=+999999999-12-31, twoStageApproval=true, members=[Person{id='null'}], " +
            "departmentHeads=[Person{id='null'}], secondStageAuthorities=[Person{id='null'}]}");
    }
}
