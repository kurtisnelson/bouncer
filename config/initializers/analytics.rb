Analytics = Segment::Analytics.new({
    write_key: ENV['SEGMENT_KEY'],
    on_error: Proc.new { |status, msg| print msg }
})
