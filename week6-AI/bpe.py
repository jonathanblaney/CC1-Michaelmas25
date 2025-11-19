from collections import Counter

# a script to do basic byte pair encoding on a given text, as a form of compression. It does not do the decode step. 

def makecharlist(string):
     index = 0
     pairs = []
     while index < len(string) - 1:
         pair = string[index] + string[index + 1]
         pairs.append(pair)
         index += 1
     mycounter = Counter(pairs)
     return(mycounter.most_common(9))

string = "It was the best of times, it was the worst of times."
print(string)
print(f"{len(string)} characters")
charlist = makecharlist(string)

replacement = 0
for char in charlist:
    string = string.replace(char[0], str(replacement))
    replacement += 1

print(string)
print(f"{len(string)} characters")

