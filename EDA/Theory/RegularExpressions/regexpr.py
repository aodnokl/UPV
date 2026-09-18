import re

# 1. CORE METHODS



# re.search(): Finds the FIRST match in the string
match_search = re.search(r"\d+", "Item 100 costs $50")
print("search():", match_search.group())  # Output: '100'

# re.findall(): Returns ALL non-overlapping matches as a list of strings
list_matches = re.findall(r"\d+", "Item 100 costs $50")
print("findall():", list_matches)  # Output: ['100', '50']

# re.finditer(): Returns an iterator of match objects (useful for indices)
match_iter = [m.span() for m in re.finditer(r"\d+", "Item 100 costs $50")]
print("finditer() spans:", match_iter)  # Output: [(5, 8), (16, 18)]

# re.sub(): Replaces matches with a replacement string
replaced_text = re.sub(r"\d+", "X", "Item 100 costs $50")
print("sub():", replaced_text)  # Output: 'Item X costs $X'

# re.split(): Splits the string by occurrences of the pattern
split_words = re.split(r"\s+", "Apple   Banana  Cherry")
print("split():", split_words)  # Output: ['Apple', 'Banana', 'Cherry']




# 2. CHARACTER CLASSES

# \d  -> Any digit [0-9]
# \D  -> Any non-digit
# \w  -> Any word character (alphanumeric + underscore) [a-zA-Z0-9_]
# \W  -> Any non-word character
# \s  -> Any whitespace character (space, tab, newline)
# \S  -> Any non-whitespace character
# .   -> Any character except newline

print("Digits (\\d):", re.findall(r"\d", "User_123!"))  # Output: ['1', '2', '3']
print("Word chars (\\w):", re.findall(r"\w", "A_1!"))    # Output: ['A', '_', '1']
print("Whitespace (\\s):", re.findall(r"\s", "A B\tC"))  # Output: [' ', '\t']
print("Any char (.):", re.findall(r"a.c", "abc a1c a!c"))# Output: ['abc', 'a1c', 'a!c']


# 3. SETS & RANGES


# [abc]    -> Matches 'a', 'b', or 'c'
# [^abc]   -> Matches any character EXCEPT 'a', 'b', or 'c'
# [a-z]    -> Matches any lowercase letter from a to z
# [0-9]    -> Matches any digit from 0 to 9

print("Set [aeiou]:", re.findall(r"[aeiou]", "hello world")) # Output: ['e', 'o', 'o']
print("Negated set [^0-9]:", re.findall(r"[^0-9]", "A1B2")) # Output: ['A', 'B']






# 4. GREEDY VS LAZY (NON-GREEDY) QUANTIFIERS

# Greedy matches as much as possible; Lazy (?) matches as little as possible.

html_tag = "<div>first</div><div>second</div>"

# * vs *?  (0 or more)
print("Greedy (*):", re.findall(r"<div>.*</div>", html_tag))   # Output: ['<div>first</div><div>second</div>']
print("Lazy (*?):", re.findall(r"<div>.*?</div>", html_tag))  # Output: ['<div>first</div>', '<div>second</div>']

# + vs +?  (1 or more)
print("Greedy (+):", re.findall(r"<.+>", html_tag))            # Output: ['<div>first</div><div>second</div>']
print("Lazy (+?):", re.findall(r"<.+?>", html_tag))           # Output: ['<div>', '</div>', '<div>', '</div>']

# ? vs ??  (0 or 1)
print("Greedy (?):", re.findall(r"a?", "a"))                  # Output: ['a', '']
print("Lazy (??):", re.findall(r"a??", "a"))                  # Output: ['', 'a']

# {n,m} vs {n,m}?  (between n and m times)
numbers_str = "123456"
print("Greedy ({2,4}):", re.findall(r"\d{2,4}", numbers_str)) # Output: ['1234', '56']
print("Lazy ({2,4}?):", re.findall(r"\d{2,4}?", numbers_str))# Output: ['12', '34', '56']






# 5. ANCHORS & BOUNDARIES

# ^  -> Start of string (or line in MULTILINE mode)
# $  -> End of string (or line in MULTILINE mode)
# \b -> Word boundary

print("Starts with (^):", re.findall(r"^Hello", "Hello world"))     # Output: ['Hello']
print("Ends with ($):", re.findall(r"world$", "Hello world"))       # Output: ['world']
print("Word boundary (\\b):", re.findall(r"\bcat\b", "cat scatter")) # Output: ['cat']






# 6. CAPTURING GROUPS & LOOKAROUNDS

# ()     -> Group patterns together and capture matched text
# (?=)   -> Positive lookahead (followed by pattern)
# (?!)   -> Negative lookahead (NOT followed by pattern)
# (?<=)  -> Positive lookbehind (preceded by pattern)
# (?<! ) -> Negative lookbehind (NOT preceded by pattern)

email_match = re.search(r"([\w\.-]+)@([\w\.-]+)\.([a-z]+)", "user@example.com")
print("Full match (group 0):", email_match.group(0)) # Output: 'user@example.com'
print("Username (group 1):", email_match.group(1))   # Output: 'user'
print("Domain (group 2):", email_match.group(2))     # Output: 'example'
print("TLD (group 3):", email_match.group(3))        # Output: 'com'
print("All groups tuple:", email_match.groups())     # Output: ('user', 'example', 'com')

# Lookarounds
prices = "$10 €20 30USD"
print("Positive lookbehind (?<=\\$):", re.findall(r"(?<=\$)\d+", prices)) # Output: ['10']
print("Positive lookahead (?=USD):", re.findall(r"\d+(?=USD)", prices))   # Output: ['30']





# 7. COMMON FLAGS


# re.IGNORECASE (re.I) -> Case-insensitive matching
# re.MULTILINE  (re.M) -> ^ and $ match start/end of each line
# re.DOTALL     (re.S) -> Dot '.' matches newlines as well

print("IgnoreCase:", re.findall(r"python", "Python PYTHON python", re.IGNORECASE))
# Output: ['Python', 'PYTHON', 'python']

print("DotAll:", re.findall(r"a.*b", "a\nb", re.DOTALL))
# Output: ['a\nb']