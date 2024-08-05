
movies = {'hum':'10:00 am',
          'dil': '01:00 pm',
          'bill': '04:00 pm'}

print('Movie List:')
for key in movies:
    print(key)

lookFor = input('Enter your movie name: ')

showtime = movies.get(lookFor)

if showtime == None:
    print(lookFor, 'movie is not playing')
else:
    print('Movie', lookFor, 'wil play at', showtime)
