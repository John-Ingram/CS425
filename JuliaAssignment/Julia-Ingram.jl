# Assignment: Julia Assignment
# Course: CS 425
# Instructor: Dr. Delugach
# Author: John Ingram
# Date: 11/24/2023

# Design:
# This program is designed to read information about Students, Courses, and Course Registrations
# from a file and then output the information in a formatted way.
# Since Julia is not object oriented, I used structs to create the types for the data.
# I then created functions to read the data from the file, parse the data into the types,
# and then register the students and courses. 
# I then print the students and courses with their registrations.


# Create the types
# Create the student type
struct Student
    id::String
    name::String
    courses::Array{String}
end

# Create the course type
struct Course
    id::String
    name::String
    students::Array{String}
end

# Create the registration type
struct Registration
    studentId::String
    courseId::String
end

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

# Function to parse the data into it's type
# takes in an array of strings
function parseData(data, type)
    # Create a new list of objects
    objects = []
    # Loop through the data
    for line in data
        # Split the line into the id and the name
        id, name = split(line, limit=2)
        # Remove leading and trailing whitespace from the id and name
        id = strip(id)
        name = strip(name)
        # Create a new object
        if type == "students"
            object = Student(id, name, [])
        elseif type == "courses"
            object = Course(id, name, [])
        elseif type == "registrations"
            object = Registration(id, name)
        else
            println("Error: Invalid type")
            return
        end
        # Add the object to the list of objects
        push!(objects, object)
    end
    # Return the list of objects
    return objects
end

# Function to take in a list of students, courses, and registrations 
# and add the course registrations to the students and the student registrations to the courses
function register(students, courses, registrations)
    # Loop through the registrations
    for registration in registrations
        # Find the student and course in the lists of students and courses
        student = students[findfirst(x -> x.id == registration.studentId, students)]
        course = courses[findfirst(x -> x.id == registration.courseId, courses)]
        # Create the course registration string and the student registration string
        courseRegistration = course.name * " (Course ID: " * course.id * ")"
        studentRegistration = student.name * " (Student ID: " * student.id * ")"
        # Add the course registration to the student
        push!(student.courses, courseRegistration)
        # Add the student registration to the course
        push!(course.students, studentRegistration)
    end
end

students, courses, registrations = readData("register.txt")
students = parseData(students, "students")
courses = parseData(courses, "courses")
registrations = parseData(registrations, "registrations")

register(students, courses, registrations)

println("\nStudents:")
for student in students
    println("\tStudent: " * student.name * " (Student ID: " * student.id * ")")
    # Print the courses with the fist course on that line, and the rest indented
    print("\tCourses: ")
    for course in student.courses
        # Don't indent the first course
        if course == student.courses[1]
            print(course)
        else
            print("\n\t\t ", course)
        end
    end
    println("\n")
end

println("\nCourses:")
for course in courses
    println("\tCourse: " * course.name * " (Course ID: " * course.id * ")")
    # Print the students with the fist student on that line, and the rest indented
    print("\tStudents: ")
    for student in course.students
        # Don't indent the first student
        if student == course.students[1]
            print(student)
        else
            print("\n\t\t  ", student)
        end
    end
    println("\n")
end

# I enjoyed messing around with Julia. One thing that really shocked me was how intuitive the syntax was.
# When learing a new language, I will often assume syntax, and then be wrong and look it up. But with Julia,
# I was often right about the syntax. Having types instead of objects felt a little odd, but my code wound
# up being very simple to writem and easy to read. I didn't implement the student and course counts, because
# tallying those would have required a function to operate on each list. I realize that the total number of
# function calls may have been similar to an object oriented solution, but I feel like the code would be 
# far less clean. I definitely see the appeal of Julia for data science, but since I'm not a data scientist, 
# I don't think I'll be using it much. I would use Julia before R or Matlab, but I would probably use 
# Python before Julia, since I'm more familiar with Python.