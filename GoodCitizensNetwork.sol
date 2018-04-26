pragma solidity ^0.4.11;

//A volunteer time record management system needs to keep track of volunteer Events

//Ethereum addresses can be thought of as primary keys, as they are uniquely linked to individuals or

//organizations

contract CoreCode {

event NewVolunteerEvent(string _name, string _description);
event VolunteerEventSetActive(string _name, string _description);

modifier isOwnerVolEvent(uint _volunteerEventId) {
    require(msg.sender == eventIdToOwner[_volunteerEventId]);
    _;
}

struct Organization {

    string name;

}

// maybe we redefine Volunteer as a regular user, might be better for general use cases
struct User {

    string name;
    uint32 volunteerHours;
    uint256[] eventsIdRegisteredFor; // list of event id vol is registered for
}

//A volunteerEvent struct is needed with the following attributes:

struct VolunteerEvent {

    string name;
    string description;
    bool confirmed; // what is confirmed?
    bool active;
    uint[] volunteers; // user ids that have registered

}

mapping (uint256 => string) orgIdToOrgName; //maps organization id to their name

mapping (uint256 => address) eventIdToOwner; // get owner of event by ID (good for ownership check)

mapping (address => uint256) ownerEventCount; // total events owner has (might be useful)

mapping (address => uint256) addressToUserId; // get user id from address

VolunteerEvent[] public volunteerEvents;
User[] public users;


function _createEvent(string _name, string _description) internal {
    uint _id = volunteerEvents.push(VolunteerEvent(_name, _description, false, false, new uint[](0)))-1;
    eventIdToOwner[_id] = msg.sender;
    ownerEventCount[msg.sender]++;
    emit NewVolunteerEvent(_name, _description);
}

function _createUser(string name) {
    uint _id = users.push(User(name, 0, new uint256[](0))) - 1;
    addressToUserId[msg.sender] =_id;
}


//returns all the events a volunteer is found in
//another mapping may be neccesary declared at top

function getEventsByVolunteer(address _volunteerAddress) {

    

}

function getVolunteersRegisteredForEvent(uint _volunteerEventId) view isOwnerVolEvent(_volunteerEventId) returns (uint[]) {
    return volunteerEvents[_volunteerEventId].volunteers;
    // i wanted to return a list of Users / user names but User[] / string[] is not supported.
    // what we can do is get a list of all the users based on their id
}

function activateEvent(uint256 _volunteerEventId) isOwnerVolEvent(_volunteerEventId) {

    //owner needs to be msg.sender, as if they own the event, they can change it
    //set active to true
    volunteerEvents[_volunteerEventId].active = true;
    emit VolunteerEventSetActive(volunteerEvents[_volunteerEventId].name, volunteerEvents[_volunteerEventId].description);

}

function register(uint256 _volunteerEventId) {

    //pushes the User at address msg.sender (a volunteer) to volunteerEvent.volunteers[]
    // adds event to registered events for user at address msg.sender
    volunteerEvents[_volunteerEventId].volunteers.push(addressToUserId[msg.sender]);
    users[addressToUserId[msg.sender]].eventsIdRegisteredFor.push(_volunteerEventId);

}

function volunteerLoggingHours(uint256 _volunteerEventId, uint32 _hours) public {
    // logs hours to User msg.sender
    users[addressToUserId[msg.sender]].volunteerHours += _hours;
}


}