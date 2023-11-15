# Assignment: Ruby Assignment
# Course: CS 425
# Instructor: Dr. Delugach
# Author: John Ingram
# Date: 11/13/2023

# Design:
# This program is designed to read information about Students, Courses, and Course Registrations
# from a file and then output the information in a formatted way.
# It is designed to be very object oriented, with a class for each of the three types of objects
# There are three main classes, Student, Course, and Registration. There are also two helper classes,
# Util and Main. Util provides some shared methods for the program, and
# Main ties it all together by running the various methods in the correct order, and printing the output
# There is really no need for the Util and Main classes, but I felt like putting everything in a class
# would be a good way to organize the program.

# The program is designed to be very flexible, and uses only a single line to parse each
# different type of object. This is done by using a proc to show off how powerful ruby's onelines can be.
# I chose to create the Registration class to handle the registration of students for courses.
# This is almost certainly not the fastest option, but it does make the code very readable,
# and reuses more logic



# Util Class, Provides shared methods for the program
class Util
    # Method to read a file and return the parsed into
    # Part 1 Student ids and name
    # Part 2 Course CRNs and names
    # Part 3 Student ids and CRNs
    def self.read_file(file_name = "register.txt")
        file = File.open(file_name, "r")
        contents = []
        file.each_line do |line|
            contents.push(line)
        end
        file.close

        # Split the contents into the three sections
        # Each section is seperated by a blank line
        part1 = []
        part2 = []
        part3 = []
        section = 1
        contents.each do |line|
            if line == "\n"
                section += 1
            else
                case section
                when 1
                    part1.push(line)
                when 2
                    part2.push(line)
                when 3
                    part3.push(line)
                else
                    puts "Error: Section #{section} not found"
                end
            end
        end

        return part1, part2, part3
    end

    # Method to parse a list of lines into a list some type of object that has a constructor that takes two arguments
    def self.split_into(lines, type)
        objects = []
        lines.each do |line|
            object = line.split(" ")
            # Proc to split the object into the first "word" and the rest of the line
            split = Proc.new { |o,i, l| o.new(i[0], l[i[0].length..-1].strip)}

            # Add the result of the split to the list of objects
            # This doesn't need to be a proc, but I wanted to see if I still remembered how to use them (I do)
            objects.push(split.call(type, object, line))
            # Another nifty thing about this approach is that I can use that single line
            # to split everything into objects. If I didn't use a proc, it could actually be on a single line
        end
        return objects
    end

end

# Student Class, Provides the student object
class Student
    # Has a student id, name, and list of CRNs
    attr_accessor :id, :name, :crns
    # Constructor
    def initialize(id, name)
        @id = id
        @name = name
        @crns = []
    end

    # Method to add a CRN to the student
    def add_course(crn)
        @crns.push(crn)
    end

    # To string method
    def to_s
        formatted_crns = ""
        @crns.each do |crn|
            formatted_crns += "\n\t#{crn}"
        end
        return "Student: #{@name} (A#: #{@id}) taking #{@crns.length} course(s): #{formatted_crns}"
    end
end

# Course Class, Provides the course object
class Course
    # Has a CRN, name, and list of students
    attr_accessor :crn, :name, :students
    # Constructor
    def initialize(crn, name)
        @crn = crn
        @name = name
        @students = []
    end

    # Method to add a student to the course
    def add_student(student)
        @students.push(student)
    end

    # To string method
    def to_s
        formatted_students = ""
        @students.each { |s| formatted_students += "\n\t #{s.name}"}

        return "Course: #{@name} (crn: #{@crn}) with an enrolment of #{@students.length} #{formatted_students}"
    end
end

# Registration Class, Provides the registration object
# Which has a method to register a student for a course
class Registration
    # Constructor
    def initialize(studentID, crn)
        @studentID = studentID
        @crn = crn
    end

    # Given a list of students and a list of courses, register the
    # student for the course
    def register(students, courses)
        # Find the student
        student = students.find { |student| student.id == @studentID }
        # Find the course
        course = courses.find { |course| course.crn == @crn }
        # Add the student to the course
        course.add_student(student)
        # Add the course to the student
        student.add_course(course.name)
    end

end

# Main Class, Provides the main functionality of the program
class Main
    # Method to run the program
    def self.run()
        section1, section2, section3 = Util.read_file()
        students = Util.split_into(section1, Student)
        courses = Util.split_into(section2, Course)
        registrations = Util.split_into(section3, Registration)

        # Register the students for the courses
        registrations.each { |r| r.register(students, courses)}

        # Print the output
        # Ruby's map is really cool. By using some other shorthand (&:to_s)
        # I can print the output in a single line
        puts ["Students:", students.map(&:to_s), "\n\nCourses:", courses.map(&:to_s)].join("\n")

        # Obviously, that is a little hard to read, but it does the same thing as this.
        # It just assembles the output into a single string, and then prints it.
        # Honestly it may be a little faster than this:
        # puts "Students:"
        # students.each {|s| puts s}

        # puts "\n\nCourses:"
        # courses.each {|c| puts c}
    end
end
# Run the program
Main.run()


# Closing Thoughts:
# I really enjoyed this assignment. Ruby was the fist language I learned form a teacher as opposed to
# attempting to teach myself, so it was nice to be able to use it again. I think that Ruby is a really
# powerful language, and I think that it is a shame that it is not used more.
# I sometimes think that the syntax of using "end" to close blocks is a little clunky, but I think that
# Overall it is a very nice language.
# I really enjoy figuring out how to do things in a single line.
