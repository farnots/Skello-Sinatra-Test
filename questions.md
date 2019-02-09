# BACKEND - Programming
These can be done in any language you're comfortable with

1. Give a regular expression that detects hexadecimal numbers in a text.
For example, `0x0f4`, `0acdadecf822eeff32aca5830e438cb54aa722e3`, `8BADF00D` should be detected.

> (0[xX])?[0-9a-fA-F]+

2. Here is the pseudo code of a function that is defined recursively:
-  f(0) = 1;
-  f(1) = 3;
-  f(n)= 3 * f(n-1) - f(n-2);
Provide an implementation for ‘f’. Bonus points for a non recursive implementation.

> def fib(n, memo = {})
>	if n == 0 || n == 1
>		return n
>	end
>	memo[n] ||= fib(n-1,memo) + fib(n-2,memo)
> end

# BACKEND - MySQL

1. Write a CREATE TABLE query for a table storing information on users. It will store:
  - id,
  - firstname,
  - lastname,
  - gender,
  - email,
  - created_at

> DROP TABLE IF EXISTS Users;
> CREATE TABLE Users (
> 	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
> 	firstname VARCHAR(255),
> 	lastname VARCHAR(255),
> 	gender BOOL,
> 	email VARCHAR(255),
> 	created_at DATETIME );
> 
> INSERT INTO Users VALUES(1,'Lucas','Tarasconi',1,'lucas@tarasconi.fr', NOW() );

2. Write a query on the previous table that lists the 10 most recently added users.

> SELECT * FROM Users ORDER BY created_by ASC LIMIT 0,10

# GENERAL - Creativity
Si vous êtes Français, vous pouvez répondre en Français.

1. Describe the color yellow to someone who is blind

> Le jaune c'est la chaleur qui t'envahis, c'est le feu qui crépite, le soleil qui te brule

2. Describe the data model you’d use for a Battleship game. What are the key objects? How will your code use them?

> There are 3 main class 
> 1. The **Board** , it's the *brain* of the game with
> 		- size : Int / represent the size of the board (it's a square)
>		- round : Int / help to count the number of round
>		- hit : [(Int,Int)] / An array of tuple that represent each shot
> 		- players : Player / represente an Array of Player Object 
> 2. The **Player** in Board Object with :
> 		- id : Int / Help to find the player quicly 
> 		- name : String / To display a nice nime
>		- ships : [Ship] / an Array of Ship Object
> 3. The **Ship** in Player Object with :
> 		- id : Int / to find the ship quickly 
> 		- originPosition : (Int,Int) / a tuple of the origin position to place the ship
> 		- direction : EnumType / a enum of (.North,.South,.East,.West) to put the ship in right direction
> 		- lenght : Int / The number of element for each ship
>		- state : Boolean / Dead of Alive - To perform calculation quickly
>
> The Board is the brain that create the right number of Player with an array of Ship, it'll make ship the position of each ship is possible on the board. Each round it calculate by the Board and store the histroric of hit played by the Player. When a ship is totaly destroy, we change his state to make the calculation faster (avoid to try if the hit complete the ship at every turn)
