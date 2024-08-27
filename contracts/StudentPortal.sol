// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentPortal {
    struct Student {
        string name;
        string email;
        string dateOfBirth;
        string lga;
        string country;
        string state;
    }

    mapping(uint256 => Student) private students;
    address public owner;

    event StudentRegistered(uint256 studentId, string name, string email);
    event StudentUpdated(
        uint256 studentId,
        string name,
        string dateOfBirth,
        string lga,
        string country,
        string state
    );
    event StudentDeleted(uint256 studentId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerStudent(
        uint256 studentId,
        string memory name,
        string memory email,
        string memory dateOfBirth,
        string memory lga,
        string memory country,
        string memory state
    ) public onlyOwner {
        students[studentId] = Student(
            name,
            email,
            dateOfBirth,
            lga,
            country,
            state
        );
        emit StudentRegistered(studentId, name, email);
    }

    function updateStudent(
        uint256 studentId,
        string memory name,
        string memory dateOfBirth,
        string memory lga,
        string memory country,
        string memory state
    ) public onlyOwner {
        Student storage student = students[studentId];
        require(bytes(student.name).length > 0, "Student does not exist");
        student.name = name;
        student.dateOfBirth = dateOfBirth;
        student.lga = lga;
        student.country = country;
        student.state = state;
        emit StudentUpdated(studentId, name, dateOfBirth, lga, country, state);
    }

    function deleteStudent(uint256 studentId) public onlyOwner {
        require(
            bytes(students[studentId].name).length > 0,
            "Student does not exist"
        );
        delete students[studentId];
        emit StudentDeleted(studentId);
    }

    function getStudent(
        uint256 studentId
    )
        public
        view
        returns (
            string memory name,
            string memory email,
            string memory dateOfBirth,
            string memory lga,
            string memory country,
            string memory state
        )
    {
        require(
            bytes(students[studentId].name).length > 0,
            "Student does not exist"
        );
        Student memory student = students[studentId];
        return (
            student.name,
            student.email,
            student.dateOfBirth,
            student.lga,
            student.country,
            student.state
        );
    }

    function studentExists(uint256 studentId) public view returns (bool) {
        return bytes(students[studentId].name).length > 0;
    }
}
