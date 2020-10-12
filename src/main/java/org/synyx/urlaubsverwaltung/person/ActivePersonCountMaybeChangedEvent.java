package org.synyx.urlaubsverwaltung.person;

public class ActivePersonCountMaybeChangedEvent {

    private final int personId;

    public ActivePersonCountMaybeChangedEvent(int personId) {
        this.personId = personId;
    }

    public int getPersonId() {
        return personId;
    }
}
