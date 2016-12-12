def luhn_cc_number?(string)
  double_evens = string.split(' ').join('').split('').map.with_index do |n, i|
    i.even? ? n.to_i * 2 : n
  end

  check_sum = double_evens.map do |num|
    num.to_i > 9 ? num.to_i - 9 : num.to_i
  end.inject(:+)

  (check_sum % 10).zero?
end
