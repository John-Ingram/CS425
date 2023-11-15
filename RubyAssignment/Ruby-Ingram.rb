# Assignment: Ruby Assignment
# Course: CS 425
# Instructor: Dr. Delugach
# Author: John Ingram
# Date: 11/13/2023



# Util Class, Provides shared methods for the program
Class Util
    # Method to read a file and return the contents
    # Reads the file line by line and returns the contents
    # as an array of strings, where each string is a line
    def read_file(file_name = "register.txt")
        file = File.open(file_name, "r")
        contents = []
        file.each_line do |line|
            contents.push(line)
        end
        file.close
        return contents
    end

end

# Student information class
# Holds the information of a student