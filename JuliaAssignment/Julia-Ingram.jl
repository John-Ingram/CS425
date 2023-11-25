# Assignment: Julia Assignment
# Course: CS 425
# Instructor: Dr. Delugach
# Author: John Ingram
# Date: 11/24/2023

# Design:
# This program is designed to read information about Students, Courses, and Course Registrations
# from a file and then output the information in a formatted way.


# Read in the data from the file, making sure to only read the file once
function readData(dataPath)
    # Open the file
    file = open("register.txt")
    # Read the file into a string
    data = read(file, String)
    # Close the file
    close(file)
    # Split the string into an array of lines
    data = split(data, "\n")
    # Split the data into sections based on the blank lines
    students = data[1:findfirst(isequal(""), data)-1]
    courses = data[findfirst(isequal(""), data)+1:findlast(isequal(""), data)-1]
    registrations = data[findlast(isequal(""), data)+1:end]
    
    # Return the data
    return students, courses, registrations
end

# Function to parse the data into a dictionary {id => part before first whitespace, Content => part after first whitespace}
# takes in an array of strings
function parseData(data)
    # Create an empty dictionary
    parsedData = Dict()
    # Loop through the data
    for line in data
        # Split the line into the id and the content
        id, content = split(line, limit=2)
        # Remove leading and trailing whitespace from the id and content
        id = strip(id)
        content = strip(content)
        # Add the id and content to the dictionary
        dictToAdd = Dict()
        dictToAdd["id"] = id
        dictToAdd["content"] = []
        push!(dictToAdd["content"], content)
        # if the id is not already in the dictionary, add it othewise add the content to the existing id
        if !haskey(parsedData, id)
            parsedData[id] = dictToAdd
        else
            push!(parsedData[id]["content"], content)
        end
        
    end
    # Return the dictionary
    return parsedData
end

# Function to take in a dictionary of Students, Courses, and Registrations and return a 
# dictionary of Students with the courses they are registered for, and a dictionary of Courses
# with the students registered for them
function register(students, courses, registrations)
    # Create an empty dictionary for the students with the courses they are registered for
    # The dictionary will be {studentId => {id => studentId, name => studentName, courses => [courseId1, courseId2, ...]}}
    studentsWithCourses = Dict()
    # Create an empty dictionary for the courses with the students registered for them
    # The dictionary will be {courseId => {id => courseId, name => courseName, students => [studentId1, studentId2, ...]}}
    coursesWithStudents = Dict()
    # Loop through the registrations
    for registration in registrations
        for courseToRegister in registration[2]["content"]
            # get the student id and course id from the registration
            studentId, courseId = registration[2]["id"], courseToRegister

            # Create the strings for the student and course ids to be printed
            studentIdString = students[studentId]["content"][1] * " (Student ID: " * studentId * ")"
            courseIdString = courses[courseId]["content"][1] * " (Course ID: " * courseId * ")"

            # Add the student to the studentsWithCourses dictionary if they are not already in it
            if !haskey(studentsWithCourses, studentId)
                # Create a dictionary for the student
                student = Dict()
                # Add the student id to the dictionary
                student["id"] = studentId
                # Add the student name to the dictionary
                student["name"] = students[studentId]["content"][1]
                # Add an empty array for the courses to the dictionary
                student["courses"] = []
                # Add the student to the studentsWithCourses dictionary
                studentsWithCourses[studentId] = student
            end
            
            # Add the course to the coursesWithStudents dictionary if it is not already in it
            if !haskey(coursesWithStudents, courseId)
                # Create a dictionary for the course
                course = Dict()
                # Add the course id to the dictionary
                course["id"] = courseId
                # Add the course name to the dictionary
                course["name"] = courses[courseId]["content"][1]
                # Add an empty array for the students to the dictionary
                course["students"] = []
                # Add the course to the coursesWithStudents dictionary
                coursesWithStudents[courseId] = course
            end

            # Add the courseid to the student's courses array
            push!(studentsWithCourses[studentId]["courses"], courseIdString)
            # Add the studentid to the course's students array
            push!(coursesWithStudents[courseId]["students"], studentIdString)
        end
    end
    # Return the dictionaries
    return studentsWithCourses, coursesWithStudents
end

students, courses, registrations = readData("register.txt")
students = parseData(students)
courses = parseData(courses)
registrations = parseData(registrations)

studentsWithCourses, coursesWithStudents = register(students, courses, registrations)

println("\nStudents:")
for student in studentsWithCourses
    println("\tStudent: " * student[2]["name"] * " (Student ID: " * student[2]["id"] * ")")
    # Print the courses with the fist course on that line, and the rest indented
    print("\tCourses: ")
    for course in student[2]["courses"]
        # Don't indent the first course
        if course == student[2]["courses"][1]
            print(course)
        else
            print("\n\t\t ", course)
        end
    end
    println("\n")
end

println("\nCourses:")
for course in coursesWithStudents
    println("\tCourse: " * course[2]["name"] * " (Course ID: " * course[2]["id"] * ")")
    # Print the students with the fist student on that line, and the rest indented
    print("\tStudents: ")
    for student in course[2]["students"]
        # Don't indent the first student
        if student == course[2]["students"][1]
            print(student)
        else
            print("\n\t\t  ", student)
        end
    end
    println("\n")
end