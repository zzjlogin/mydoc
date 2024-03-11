import argparse

parser = argparse.ArgumentParser(prog='game.py')
parser.add_argument('move', choices=['rock', 'paper', 'scissors'])
print(parser.parse_args(['rock']))
#Namespace(move='rock')
print(parser.parse_args(['fire']))
#usage: game.py [-h] {rock,paper,scissors}
#game.py: error: argument move: invalid choice: 'fire' (choose from 'rock','paper', 'scissors')