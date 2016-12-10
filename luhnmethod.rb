def cc_number?(string)
  double_evens = string.split(' ').join('').split('').map.with_index \
  { |num, ind| ind.even? ? num.to_i * 2 : num }

  check_sum = double_evens.map \
  { |num| num.to_i > 9 ? num.to_i - 9 : num.to_i }.inject(:+)

  (check_sum % 10).zero?
end
