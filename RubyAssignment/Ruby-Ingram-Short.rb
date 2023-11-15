class Student
    attr_accessor :id, :name, :crns
    def initialize(id, name)
        @id, @name, @crns = id, name, []
    end
    def add_course(crn)
        @crns.push(crn)
    end
    def to_s
        formatted_crns = ""
        @crns.each { |c| formatted_crns += "\n\t #{c}"}
        return "Student: #{@name} (A#: #{@id}) taking #{@crns.length} course(s): #{formatted_crns}"
    end
end
class Course
    attr_accessor :crn, :name, :students
    def initialize(crn, name)
        @crn, @name, @students = crn, name, []
    end
    def add_student(student)
        @students.push(student)
    end
    def to_s
        formatted_students = ""
        @students.each { |s| formatted_students += "\n\t #{s.name}"}
        return "Course: #{@name} (crn: #{@crn}) with an enrolment of #{@students.length} #{formatted_students}"
    end
end
class Registration
    def initialize(studentID, crn)
        @studentID, @crn = studentID, crn
    end
    def register(students, courses)
        student = students.find { |student| student.id == @studentID }
        course = courses.find { |course| course.crn == @crn }
        course.add_student(student)
        student.add_course(course.name)
    end
end
def read_file(file_name = "register.txt")
    file, contents, part1, part2, part3, section = File.open(file_name, "r"), [], [], [], [], 1
    file.each_line {|line| contents.push(line) }
    file.close
    contents.each { |line| line == "\n" ? section += 1 : [part1, part2, part3][section-1]&.push(line)}
    return part1, part2, part3
end
def split_into(lines, type)
    objects = []
    lines.each do |line|
        object = line.split(" ")
        split = Proc.new { |o,i, l| o.new(i[0], l[i[0].length..-1].strip)}
        objects.push(split.call(type, object, line))
    end
    return objects
end
part1, part2, part3 = read_file()
students, courses, regs = split_into(part1, Student), split_into(part2, Course), split_into(part3, Registration)
regs.each { |r| r.register(students, courses)}
puts ["Students:", students.map(&:to_s), "\n\nCourses:", courses.map(&:to_s)].join("\n")
