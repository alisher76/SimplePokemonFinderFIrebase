# Card Game

from random import shuffle


# Two usefull variables for creating Cards

SUITE = 'H D S C'
RANKS = '2 3 4 5 6 7 8 9 10 J Q K A'.split()


class Deck:
    """
    This is the Deck Class this object will create a deck of cards to initiate play.
    You can then use this Deck list of cards to split in hal and give to the players.
    It will use the SUITE and RANKS to create the deck. It should also have a method for splitting / cutting the deck
    in half and shuffling the deck
    """

    def __init__(self):
        print("Creating New Ordered deck!")
        self.allcards = [(s,r) for s in SUITE for r in RANKS]


    def shuffle(self):
        print("Shuffling Deck!")
        shuffle(self.allcards)

    def split_in_half(self):
        return  (self.allcards[:26], self.allcards[26:])


class Hand:
    """
    This is the Hand Class. Each Player has a Hand, and can add or remove cards from that hand. There should be an add
    remove card method here.
    """

    def __init__(self,cards):
        self.cards = cards


    def __str__(self):
        return "Contains {} cards".format(len(self.cards))

    def add(self, added_cards):
        self.cards.extends(added_cards)


    def remove_card(self):
        return self.cards.pop()


class Player:
    """
    This is the Player class Which takes in a name and an instance of a Hand class object. The Payer can then play cards
    and check if they still have cards.
    """

    def __init__(self,name,hand):
        self.hand = hand
        self.name = name


    def play_card(self):
        drawn_card = self.hand.remove_card()
        print("{} has placed: {}".format(self.name, drawn_card))
        print("\n")
        return drawn_card


    def remove_war_cards(self):
        war_cards = []
        for x in range(3):
            war_cards.append(self.hand.cards.pop)
        return  war_cards


    def still_has_cards(self):
        """
        Return true if still has cards
        """

        return len(self.hand.cards) != 0


##################
  ##  GAME  ON   ###
##################
print("Hello To THe Game")


deck=Deck()
deck=shuffle()
half1,half2 = deck.split_in_half()


# create both Players
comp = Player("computer",  Hand(half1))
name =input("Please enter your name first")

player = Player(name, Hand(half1))

total_rounds = 0
war_count = 0


{while user.still_has_cards() and comp.still_has_cards():
        total_rounds += 1
        print("Time For a new round")
        print("here are the current standing")
        print(user.name+ "Has the count of + str(user.hand.cards")








