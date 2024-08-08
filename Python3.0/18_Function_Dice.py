import random

def roll_dice():
    total = random.randint(1,6) + random.randint(1,6)
    return total

player1total = roll_dice()
player2total = roll_dice()
print(player1total)
print(player2total)
if player1total > player2total:
    print ("Player 1 wins")
elif player2total > player1total:
    print("Player 2 wins")
else:
    print("TIE")