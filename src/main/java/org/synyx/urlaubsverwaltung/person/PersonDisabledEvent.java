package org.synyx.urlaubsverwaltung.person;

public class PersonDisabledEvent {

    private final int personId;

    public PersonDisabledEvent(int personId) {
        this.personId = personId;
    }

    public int getPersonId() {
        return personId;
    }
}
