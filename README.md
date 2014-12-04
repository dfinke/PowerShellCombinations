# Using PowerShell Classes 

Use PowerShell Classes and Script to generate and manipulate combinations and permutations

Combinations
-
A combination is a way of selecting to members from a grouping, such that (unlike permutations) the order of selection does not matter.

For example, if you have the 5 items

	ant bug cat dog elk

then the 10 possible combinations of size 3 are

	ant   bug   cat  
	ant   bug   dog  
	ant   bug   elk  
	ant   cat   dog  
	ant   cat   elk  
	ant   dog   elk  
	bug   cat   dog  
	bug   cat   elk  
	bug   dog   elk  
	cat   dog   elk  

![image](https://raw.githubusercontent.com/dfinke/PowerShellCombinations/master/images/Combinations.png)

Permuations
-
It you have the three items

	Adam John Jane

then, the six permutations of these items are

	Adam John Jane
	Adam Jane John
	John Adam Jane
	John Jane Adam
	Jane Adam John
	Jane John Adam

![image](https://raw.githubusercontent.com/dfinke/PowerShellCombinations/master/images/Permutations.png)

Deal A Hand
-
Here we simulate a deck of cards with string array with 4 values (each suit of the deck). Each array is an array of 13 values, representing the playing cards.

* `[Combination]::Choose(52,5)` - calculates there are 2,598,960 possible combinations 
* `[Combination]::new(52,5)` - generates the 5 card combinations for the playing cards
* `"$($c.Element((Get-Random $possibilities)).ApplyTo($deck))"` - Randomly chooses a combination and then "applies" to the deck

### The script

	$possibilities = [Combination]::Choose(52,5)
	$c = [Combination]::new(52,5)
	
	$deck = $(
		echo As Ks Qs Js Ts 9s 8s 7s 6s 5s 4s 3s 2s
		echo Ac Kc Qc Jc Tc 9c 8c 7c 6c 5c 4c 3c 2c
		echo Ad Kd Qd Jd Td 9d 8d 7d 6d 5d 4d 3d 2d
		echo Ah Kh Qh Jh Th 9h 8h 7h 6h 5h 4h 3h 2h
	)
	
	"$($c.Element((Get-Random $possibilities)).ApplyTo($deck))"

### In Action

![image](https://raw.githubusercontent.com/dfinke/PowerShellCombinations/master/images/DealHand.png)


Acknowledgments
-
I ported this from James McCaffrey's book [.NET Test Automation Recipes](http://www.apress.com/9781590596630)
