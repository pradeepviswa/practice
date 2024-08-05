
expenses = [10.5,8,6,5,7,10,26,6]
total = sum(expenses)
print(total)
print('Total expense is', total)
print('Total expense is $', total, sep='')

total_2 = 0
for x in expenses:
    total_2 = total_2 + x

print('Loop - Total expense is $', total_2, sep = '' )