require "date_core"

elk = <<~TXT.gsub("\n", "").chars.map(&:to_i)
9009999
0909900
9909900
0999999
9999000
0900000
9900000
TXT

date = DateTime.new(2022, 6, 4, 12)
file_name = "elk.log"

File.write(file_name, "History\n")

3.times do
  elk.each do |num|
    date += Rational(1)
    next if num.zero?

    num.times do |i|
      date_val = (date + Rational(i)/100).strftime("%Y-%m-%dT%H:%M:%SZ")
      File.open(file_name, File::APPEND|File::CREAT|File::RDWR) do |f|
        f.puts date_val
      end
      system(
        "export GIT_COMMITTER_DATE='#{date_val}';" \
        "export GIT_AUTHOR_DATE=$GIT_COMMITTER_DATE;"\
        "git add #{file_name} && git commit -m '#{date_val}'"
      )
    end
  end
  date += Rational(7)
end