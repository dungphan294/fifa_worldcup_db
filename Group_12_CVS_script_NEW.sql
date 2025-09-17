-- Step 1: Check if the database exists, and create it if it does not
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'group12_final')
BEGIN
    CREATE DATABASE group12_final;
END

USE group12_final;
GO

-- Step 2: Check if the schema exists, and create it if it does not
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'WC')
BEGIN
    EXEC('CREATE SCHEMA WC');
END

DROP TABLE IF EXISTS WC.award_winner;
DROP TABLE IF EXISTS WC.group_standing;
DROP TABLE IF EXISTS WC.tournament_statistics;
DROP TABLE IF EXISTS WC.team_statistics;
DROP TABLE IF EXISTS WC.player_statistics;
DROP TABLE IF EXISTS WC.tournament_standing;
DROP TABLE IF EXISTS WC.penalty_shootout;
DROP TABLE IF EXISTS WC.substitution;
DROP TABLE IF EXISTS WC.booking;
DROP TABLE IF EXISTS WC.goal;
DROP TABLE IF EXISTS WC.match_event;
DROP TABLE IF EXISTS WC.event_type;
DROP TABLE IF EXISTS WC.player_appearance;
DROP TABLE IF EXISTS WC.manager_appearance;
DROP TABLE IF EXISTS WC.referee_appearance;
DROP TABLE IF EXISTS WC.[match];
DROP TABLE IF EXISTS WC.manager_appointment;
DROP TABLE IF EXISTS WC.referee_appointment;
DROP TABLE IF EXISTS WC.squad;
DROP TABLE IF EXISTS WC.position;
DROP TABLE IF EXISTS WC.tournament_stage;
DROP TABLE IF EXISTS WC.player;
DROP TABLE IF EXISTS WC.referee;
DROP TABLE IF EXISTS WC.manager;
DROP TABLE IF EXISTS WC.team;
DROP TABLE IF EXISTS WC.[group];
DROP TABLE IF EXISTS WC.host_country;
DROP TABLE IF EXISTS WC.award;
DROP TABLE IF EXISTS WC.tournament;
DROP TABLE IF EXISTS WC.confederation;
DROP TABLE IF EXISTS WC.stadium;
DROP TABLE IF EXISTS WC.city;
DROP TABLE IF EXISTS WC.country;

-- Create Country table
CREATE TABLE WC.country (
    country_code nvarchar(10) NOT NULL PRIMARY KEY,
    country_name nvarchar(100) NOT NULL
);
GO

-- Create City table
CREATE TABLE WC.city (
    country_code nvarchar(10) NOT NULL,
    city_id INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    city_name nvarchar(100) NOT NULL,
    FOREIGN KEY (country_code) REFERENCES WC.country(country_code)
);
GO

-- Create Stadium table
CREATE TABLE WC.stadium (
    city_id INT NOT NULL,
    stadium_id nvarchar(100) NOT NULL PRIMARY KEY,
    stadium_name nvarchar(100) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0),
    stadium_wikipedia_link nvarchar(200) NULL,
    FOREIGN KEY (city_id) REFERENCES WC.city(city_id)
);
GO

-- Create Tournament table
CREATE TABLE WC.tournament (
    tournament_id nvarchar(100) NOT NULL PRIMARY KEY,
    tournament_name nvarchar(100) NOT NULL,
    year INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    host_won BIT NOT NULL
);
GO

-- Create Tournament-Stage table
CREATE TABLE WC.tournament_stage (
    tournament_id nvarchar(100) NOT NULL,
    stage_id nvarchar(100) NOT NULL,
    stage_name nvarchar(100) NOT NULL,
	group_stage BIT NOT NULL,
	knockout_stage BIT NOT NULL,
	start_date DATE NULL, 
	end_date DATE NULL,
	PRIMARY KEY CLUSTERED (tournament_id ASC, stage_id ASC) ON [PRIMARY],
    FOREIGN KEY (tournament_id) REFERENCES WC.tournament(tournament_id)
);
GO

-- Create Host Country table
CREATE TABLE WC.host_country (
    country_code nvarchar(10) NOT NULL,
    tournament_id nvarchar(100) NOT NULL,
    PRIMARY KEY CLUSTERED (country_code ASC, tournament_id ASC) ON [PRIMARY],
    FOREIGN KEY (country_code) REFERENCES WC.country(country_code),
    FOREIGN KEY (tournament_id) REFERENCES WC.tournament(tournament_id)
);
GO

-- Create Confederation table
CREATE TABLE WC.confederation (
	confederation_id nvarchar(100) NOT NULL PRIMARY KEY,
	confederation_name nvarchar(200) NOT NULL,
	confederation_code nvarchar(100) NOT NULL,
	confederation_wikipedia_code nvarchar(200) NULL
);
GO

-- Create Team table
CREATE TABLE WC.team (
	team_id nvarchar(100) NOT NULL PRIMARY KEY,
	team_name nvarchar(100) NOT NULL,
	team_code nvarchar(100) NOT NULL,
	men_team BIT NOT NULL,
	women_team BIT NOT NULL,
	federation_name nvarchar(200) NOT NULL,
	men_wikipedia_link nvarchar(200) NOT NULL,
	women_wikipedia_link nvarchar(200) NULL,
	federation_wikipedia_link nvarchar(200) NULL,
	confederation_id nvarchar(100) NOT NULL,
	FOREIGN KEY (confederation_id) REFERENCES WC.confederation(confederation_id)
);
GO

-- Create Player table
CREATE TABLE WC.player (
	player_id nvarchar(100) NOT NULL PRIMARY KEY,
	given_name nvarchar(100) NOT NULL,
	family_name nvarchar(100) NOT NULL,
	birth_date DATE NOT NULL,
	female BIT NOT NULL,
	player_wikipedia_link nvarchar(100) NULL,
	country_code nvarchar(10) NULL,
    FOREIGN KEY (country_code) REFERENCES WC.country(country_code)
);
GO

-- Create Position table
CREATE TABLE WC.position (
    position_id nvarchar(10) NOT NULL PRIMARY KEY,
    position_name nvarchar(100) NOT NULL
);
GO

-- Create Manager table 
CREATE TABLE WC.manager (
	manager_id nvarchar(100) NOT NULL PRIMARY KEY,
	given_name nvarchar(100) NOT NULL,
	family_name nvarchar(100) NOT NULL,
	female BIT NOT NULL,
	manager_wikipedia_link nvarchar(100) NULL,
	country_code nvarchar(10) NULL,
    FOREIGN KEY (country_code) REFERENCES WC.country(country_code)
);
GO

-- Create Referee table 
CREATE TABLE WC.referee (
	referee_id nvarchar(100) NOT NULL PRIMARY KEY,
	given_name nvarchar(100) NOT NULL,
	family_name nvarchar(100) NOT NULL,
	female BIT NOT NULL,
	referee_wikipedia_link nvarchar(100) NULL,
	confederation_id nvarchar(100) NOT NULL,
	country_code nvarchar(10) NULL,
	FOREIGN KEY (confederation_id) REFERENCES WC.confederation(confederation_id),
    FOREIGN KEY (country_code) REFERENCES WC.country(country_code)
);
GO

-- Create Group table
CREATE TABLE WC.[group] (
	group_id nvarchar(10) NOT NULL PRIMARY KEY,
	group_name nvarchar(100) NOT NULL
);
GO

-- Create Manager Appointment table
CREATE TABLE WC.manager_appointment (
    tournament_id nvarchar(100) NOT NULL,
	manager_id nvarchar(100) NOT NULL,
	team_id nvarchar(100) NOT NULL,
    PRIMARY KEY CLUSTERED (tournament_id ASC, manager_id ASC, team_id ASC) ON [PRIMARY],
    FOREIGN KEY (tournament_id) REFERENCES WC.tournament(tournament_id),
    FOREIGN KEY (manager_id) REFERENCES WC.manager(manager_id),
    FOREIGN KEY (team_id) REFERENCES WC.team(team_id)
);
GO

-- Create Manager Appointment table
CREATE TABLE WC.referee_appointment (
    tournament_id nvarchar(100) NOT NULL,
	referee_id nvarchar(100) NOT NULL,
    PRIMARY KEY CLUSTERED (tournament_id ASC, referee_id ASC) ON [PRIMARY],
    FOREIGN KEY (referee_id) REFERENCES WC.referee(referee_id),
    FOREIGN KEY (tournament_id) REFERENCES WC.tournament(tournament_id)
);
GO

-- Create Squad table
CREATE TABLE WC.squad (
    tournament_id nvarchar(100) NOT NULL,
    team_id nvarchar(100) NOT NULL,
    player_id nvarchar(100) NOT NULL,
    position_id nvarchar(10) NOT NULL, 
	shirt_number INT NOT NULL,
    PRIMARY KEY CLUSTERED (tournament_id, team_id, player_id) ON [PRIMARY],
    FOREIGN KEY (tournament_id) REFERENCES WC.tournament(tournament_id),
    FOREIGN KEY (team_id) REFERENCES WC.team(team_id),
    FOREIGN KEY (player_id) REFERENCES WC.player(player_id),
    FOREIGN KEY (position_id) REFERENCES WC.position(position_id) -- Foreign key to position table
);
GO

-- Create Match table
CREATE TABLE WC.[match] (
	tournament_id nvarchar(100) NOT NULL,
	match_id nvarchar(100) NOT NULL PRIMARY KEY,
	match_name nvarchar(200) NOT NULL,
	stadium_id nvarchar(100) NOT NULL,
	stage_id nvarchar(100) NOT NULL,
	group_id nvarchar(10) NULL,
	home_team_id nvarchar(100) NOT NULL,
	away_team_id nvarchar(100) NOT NULL,
	match_date DATE NOT NULL,
	match_time TIME NOT NULL,
	home_team_win BIT DEFAULT 0,
	away_team_win BIT DEFAULT 0,
	draw BIT DEFAULT 0,
	FOREIGN KEY (tournament_id) REFERENCES WC.tournament(tournament_id),
	FOREIGN KEY (stadium_id) REFERENCES WC.stadium(stadium_id),
	FOREIGN KEY (home_team_id) REFERENCES WC.team(team_id),
	FOREIGN KEY (away_team_id) REFERENCES WC.team(team_id),
	FOREIGN KEY (group_id) REFERENCES WC.[group](group_id),
	FOREIGN KEY (tournament_id, stage_id) REFERENCES WC.tournament_stage(tournament_id, stage_id)
);
GO

-- Create Player Appearance table
CREATE TABLE WC.player_appearance (
    player_id nvarchar(100) NOT NULL,
    match_id nvarchar(100) NOT NULL,
    position_id nvarchar(10) NOT NULL, 
    starter BIT NOT NULL,
    substitute BIT NOT NULL,
    PRIMARY KEY CLUSTERED (player_id, match_id) ON [PRIMARY],
    FOREIGN KEY (match_id) REFERENCES WC.[match](match_id),
    FOREIGN KEY (position_id) REFERENCES WC.position(position_id) -- Foreign key to sub-position table
);
GO

-- Create Manager Appearance table
CREATE TABLE WC.manager_appearance (
	manager_id nvarchar(100) NOT NULL,
    match_id nvarchar(100) NOT NULL,
	team_id nvarchar(100) NOT NULL,
    PRIMARY KEY CLUSTERED (manager_id ASC, match_id ASC, team_id ASC) ON [PRIMARY],
    FOREIGN KEY (manager_id) REFERENCES WC.manager(manager_id),
    FOREIGN KEY (match_id) REFERENCES WC.[match](match_id),
    FOREIGN KEY (team_id) REFERENCES WC.team(team_id)
);
GO

-- Create Manager Appearance table
CREATE TABLE WC.referee_appearance (
	referee_id nvarchar(100) NOT NULL,
    match_id nvarchar(100) NOT NULL,
    PRIMARY KEY CLUSTERED (referee_id ASC, match_id ASC) ON [PRIMARY],
    FOREIGN KEY (referee_id) REFERENCES WC.referee(referee_id),
    FOREIGN KEY (match_id) REFERENCES WC.[match](match_id)
);
GO

-- Create Event Type table
CREATE TABLE WC.event_type (
    event_type_id nvarchar(100) NOT NULL PRIMARY KEY,
    event_name nvarchar(100) NOT NULL,
	description nvarchar(255) NULL
);
GO

-- Create Event table
CREATE TABLE WC.match_event (
    event_id nvarchar(255) NOT NULL PRIMARY KEY,
    event_type_id nvarchar(100) NOT NULL,
    minute_regulation INT NULL,
    minute_stoppage INT NULL,
    match_id nvarchar(100) NOT NULL,
    team_id nvarchar(100) NOT NULL,
    player_id nvarchar(100) NOT NULL,
    FOREIGN KEY (event_type_id) REFERENCES WC.event_type(event_type_id),
    FOREIGN KEY (match_id) REFERENCES WC.[match](match_id),
    FOREIGN KEY (team_id) REFERENCES WC.team(team_id),
    FOREIGN KEY (player_id) REFERENCES WC.player(player_id)
);
GO

-- Create Goal table
CREATE TABLE WC.goal (
	event_id nvarchar(255) NOT NULL PRIMARY KEY,
	own_goal BIT NOT NULL,
	is_penalty BIT NOT NULL,
	FOREIGN KEY (event_id) REFERENCES WC.match_event(event_id)
);
GO

-- Create Booking table
CREATE TABLE WC.booking (
	event_id nvarchar(255) NOT NULL PRIMARY KEY,
	yellow_card BIT NOT NULL,
	second_yellow_card BIT NOT NULL,
	red_card BIT NOT NULL,
	sent_off BIT NOT NULL,
	FOREIGN KEY (event_id) REFERENCES WC.match_event(event_id)
);
GO

-- Create Substitution table
CREATE TABLE WC.substitution (
	event_id nvarchar(255) NOT NULL PRIMARY KEY,
	player_in nvarchar(100) NOT NULL,
	player_out nvarchar(100) NOT NULL,
	FOREIGN KEY (event_id) REFERENCES WC.match_event(event_id)
);
GO

-- Create Penalty Shootout table
CREATE TABLE WC.penalty_shootout (
	event_id nvarchar(255) NOT NULL PRIMARY KEY,
	converted BIT NOT NULL,
	FOREIGN KEY (event_id) REFERENCES WC.match_event(event_id)
);
GO

-- Create Award table
CREATE TABLE WC.award (
    award_id nvarchar(100) NOT NULL PRIMARY KEY,
    award_name nvarchar(100) NOT NULL,
    award_description nvarchar(255) NULL,
	year_introduce INT NOT NULL
);

-- Create Group Standing table
CREATE TABLE WC.group_standing (
    tournament_id nvarchar(100) NOT NULL,
    group_id nvarchar(10) NOT NULL,
    stage_id nvarchar(100) NOT NULL,
    team_id nvarchar(100) NOT NULL,
	position INT DEFAULT 0,
    played INT DEFAULT 0,
    wins INT DEFAULT 0,
    draws INT DEFAULT 0,
    losses INT DEFAULT 0,
    goals_for INT DEFAULT 0,
    goals_against INT DEFAULT 0,
    goals_difference AS (goals_for - goals_against), -- Calculated column
    points AS ( (wins*3) + (draws*1) ), -- Total points for wins and draws
    fair_play_points INT DEFAULT 0, -- Deducted based on yellow/red cards
    [advanced] BIT DEFAULT 0, -- Whether the team advanced to knockout stage
    PRIMARY KEY CLUSTERED (tournament_id ASC, team_id ASC) ON [PRIMARY],
    FOREIGN KEY (group_id) REFERENCES WC.[group](group_id),
    FOREIGN KEY (tournament_id) REFERENCES WC.tournament(tournament_id),
    FOREIGN KEY (team_id) REFERENCES WC.team(team_id),
    FOREIGN KEY (tournament_id, stage_id) REFERENCES WC.tournament_stage(tournament_id, stage_id)
);
GO

-- TRIGGER 2 – Tournament Statistics
CREATE TABLE WC.player_statistics (
    tournament_id nvarchar(100) NOT NULL,
    player_id nvarchar(100) NOT NULL,
    tournaments INT DEFAULT 0,
    matches INT DEFAULT 0,
    goals INT DEFAULT 0,
    yellow_cards INT DEFAULT 0,
    red_cards INT DEFAULT 0,
	sent_offs INT DEFAULT 0,
    PRIMARY KEY CLUSTERED (tournament_id ASC, player_id ASC) ON [PRIMARY],
    FOREIGN KEY (player_id) REFERENCES WC.player(player_id),
    FOREIGN KEY (tournament_id) REFERENCES WC.tournament(tournament_id)
);
GO

CREATE TABLE WC.team_statistics (
    tournament_id nvarchar(100) NOT NULL,
	team_id nvarchar(100) NOT NULL,
	tournaments INT DEFAULT 0,
	performance nvarchar(100) NULL, 
    matches INT DEFAULT 0,
    goals INT DEFAULT 0,
	goals_against INT DEFAULT 0,
    yellow_cards INT DEFAULT 0,
    red_cards INT DEFAULT 0,
	wins INT DEFAULT 0,
	draws INT DEFAULT 0,
	losses INT DEFAULT 0,
    PRIMARY KEY CLUSTERED (tournament_id ASC, team_id ASc) ON [PRIMARY],
    FOREIGN KEY (team_id) REFERENCES WC.team(team_id),
    FOREIGN KEY (tournament_id) REFERENCES WC.tournament(tournament_id)
);
GO

CREATE TABLE WC.tournament_standing (
    tournament_id nvarchar(100) NOT NULL,
    team_id nvarchar(100) NOT NULL,
    position INT NOT NULL,
    PRIMARY KEY CLUSTERED (tournament_id ASC, team_id ASC) ON [PRIMARY],
    FOREIGN KEY (tournament_id) REFERENCES WC.tournament(tournament_id),
    FOREIGN KEY (team_id) REFERENCES WC.team(team_id)
);
GO

CREATE TABLE WC.tournament_statistics (
    tournament_id nvarchar(100) NOT NULL PRIMARY KEY,
	count_matches INT DEFAULT 0,
	count_teams INT DEFAULT 0,
    goals INT DEFAULT 0,
    yellow_cards INT DEFAULT 0,
    red_cards INT DEFAULT 0,
	sent_offs INT DEFAULT 0,
    FOREIGN KEY (tournament_id) REFERENCES WC.tournament(tournament_id)
);
GO

-- Create Award Winner table
CREATE TABLE WC.award_winner (
    tournament_id nvarchar(100) NOT NULL,
    award_id nvarchar(100) NOT NULL,
	team_id nvarchar(100) NULL, 
    player_id nvarchar(100) NULL,
	PRIMARY KEY CLUSTERED (award_id ASC, tournament_id ASC) ON [PRIMARY],
    FOREIGN KEY (award_id) REFERENCES WC.award(award_id),
    FOREIGN KEY (player_id) REFERENCES WC.player(player_id),
    FOREIGN KEY (tournament_id) REFERENCES WC.tournament(tournament_id)
);
GO

-- TRIGGER TO CALCULATE DATA

-- TRIGGER TO CALCULATE DATA

-- Create Trigger
CREATE TRIGGER trg_after_tournament_insert_tournament_statistics
ON  WC.tournament
AFTER INSERT, UPDATE
AS
BEGIN
	-- Insert into team_statistic table
	INSERT INTO  WC.tournament_statistics(tournament_id)
    SELECT i.tournament_id
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 
        FROM  WC.tournament_statistics ts
        WHERE ts.tournament_id = i.tournament_id
    );
	-- Update the tournament_statistics table 
	UPDATE ts
    SET ts.tournament_id = i.tournament_id
    FROM WC.tournament_statistics AS ts
    JOIN inserted i
    ON ts.tournament_id = i.tournament_id;
END;
GO


-- Create Trigger
CREATE TRIGGER trg_after_group_standing_insert_team_statistics
ON  WC.group_standing
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	-- Insert into team_statistic table
	INSERT INTO  WC.team_statistics(team_id, tournament_id, tournaments)
    SELECT i.team_id, i.tournament_id,
           (SELECT COUNT(DISTINCT s.tournament_id)
            FROM  WC.group_standing s
            WHERE s.team_id = i.team_id)
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 
        FROM  WC.team_statistics ts
        WHERE ts.team_id = i.team_id
        AND ts.tournament_id = i.tournament_id
    );
	-- Update the tournaments in team_statistic table for the inserted squad
	UPDATE ts
    SET ts.tournaments = 
        (SELECT COUNT(DISTINCT s.tournament_id)
         FROM  WC.group_standing s
         WHERE s.team_id = ts.team_id)
    FROM WC.team_statistics ts
    JOIN inserted i
    ON ts.team_id = i.team_id;
END;
GO

CREATE TRIGGER trg_after_squad_insert_player_statistics
ON  WC.squad
AFTER INSERT
AS
BEGIN
    -- Insert into player_statistics table
    INSERT INTO  WC.player_statistics (player_id, tournament_id, tournaments)
    SELECT i.player_id, i.tournament_id,
           (SELECT COUNT(DISTINCT s.tournament_id)
            FROM  WC.squad s
            WHERE s.player_id = i.player_id)
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1 
        FROM  WC.player_statistics ps
        WHERE ps.player_id = i.player_id
        AND ps.tournament_id = i.tournament_id
    );

    -- Update the tournaments in player_statistics table for the inserted squad
    UPDATE ps
    SET ps.tournaments = 
        (SELECT COUNT(DISTINCT s.tournament_id)
         FROM  WC.squad s
         WHERE s.player_id = ps.player_id)
    FROM WC.player_statistics ps
    JOIN inserted i
    ON ps.player_id = i.player_id;
END;
GO


CREATE TRIGGER [WC].[trg_match_update_team_statistics]
ON  [WC].[match]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	UPDATE stats
    SET stats.matches = combined.matches
    FROM (
        -- Group and count the matches played by each team in each tournament
        SELECT A.tournament_id, A.team_id, COUNT(DISTINCT A.match_id) AS matches
			FROM  (
				SELECT tournament_id, home_team_id AS team_id, match_id
				FROM  WC.match
				UNION ALL
				SELECT tournament_id, away_team_id AS team_id, match_id
				FROM  WC.match
			) AS A
		GROUP BY A.tournament_id, A.team_id
    ) AS combined
    INNER JOIN  WC.team_statistics AS stats
        ON stats.tournament_id = combined.tournament_id
        AND stats.team_id = combined.team_id;

	-- INSERT statement to add new rows if they don't exist
    INSERT INTO  WC.team_statistics (tournament_id, team_id, matches)
    SELECT combined.tournament_id, combined.team_id, combined.matches
    FROM (
        SELECT A.tournament_id, A.team_id, COUNT(DISTINCT A.match_id) AS matches
			FROM  (
				SELECT tournament_id, home_team_id AS team_id, match_id
				FROM  WC.match
				UNION ALL
				SELECT tournament_id, away_team_id AS team_id, match_id
				FROM  WC.match
			) AS A
		GROUP BY A.tournament_id, A.team_id
    ) AS combined
    WHERE NOT EXISTS (
        SELECT 1
        FROM  WC.team_statistics stats
        WHERE stats.tournament_id = combined.tournament_id
        AND stats.team_id = combined.team_id
    );
END;
GO
GO

CREATE TRIGGER trg_update_player_statistics
ON WC.player_appearance
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Update existing records in the player_statistics table
    UPDATE stats
    SET stats.matches = combined.matches
    FROM WC.player_statistics AS stats
    INNER JOIN (
		SELECT 
            TEMP.tournament_id,
            TEMP.player_id, 
            COUNT(DISTINCT TEMP.match_id) AS matches
        FROM (
            SELECT 
                PA.player_id, 
                'WC-' + SUBSTRING(PA.match_id, 3, 4) AS tournament_id,
                PA.match_id
            FROM WC.player_appearance AS PA
            INNER JOIN WC.squad AS S ON PA.player_id = S.player_id 
            AND 'WC-' + SUBSTRING(PA.match_id, 3, 4) = S.tournament_id
        ) AS TEMP
        GROUP BY 
            TEMP.tournament_id,
            TEMP.player_id
	) AS combined 
        ON stats.tournament_id = combined.tournament_id
        AND stats.player_id = combined.player_id;

    -- Insert new records if they don't exist
    INSERT INTO WC.player_statistics (tournament_id, player_id, matches)
    SELECT combined.tournament_id, combined.player_id, combined.matches
    FROM (
		SELECT 
            TEMP.tournament_id,
            TEMP.player_id, 
            COUNT(DISTINCT TEMP.match_id) AS matches
        FROM (
            SELECT 
                PA.player_id, 
                'WC-' + SUBSTRING(PA.match_id, 3, 4) AS tournament_id,
                PA.match_id
            FROM WC.player_appearance AS PA
            INNER JOIN WC.squad AS S ON PA.player_id = S.player_id 
            AND 'WC-' + SUBSTRING(PA.match_id, 3, 4) = S.tournament_id
        ) AS TEMP
        GROUP BY 
            TEMP.tournament_id,
            TEMP.player_id
	) AS combined
    WHERE NOT EXISTS (
        SELECT 1
        FROM WC.player_statistics AS stats
        WHERE stats.tournament_id = combined.tournament_id
        AND stats.player_id = combined.player_id
    );
END;
GO



CREATE TRIGGER trg_update_goals_stats
ON  WC.goal
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Declare a temporary table to hold intermediate results
    CREATE TABLE #TempGroupGoals (
        tournament_id NVARCHAR(100),
        team_id NVARCHAR(100),
        goals_for INT,
        goals_against INT
    );

	-- Declare a temporary table to hold intermediate results
    CREATE TABLE #TempTeamGoals (
        tournament_id NVARCHAR(100),
        team_id NVARCHAR(100),
        goals_for INT,
        goals_against INT
    );

	 -- Declare a temporary table to hold intermediate results
    CREATE TABLE #TempPlayerGoals (
        tournament_id NVARCHAR(100),
        player_id NVARCHAR(100),
        goals_for INT
    );

    -- Insert aggregated goal data into the temporary table
    INSERT INTO #TempGroupGoals (tournament_id, team_id, goals_for, goals_against)
	SELECT 
		TEMP.tournament_id, 
		TEMP.team_id, 
		SUM(TEMP.goals_for), 
		SUM(TEMP.goals_against)
	FROM (	SELECT
				GS.tournament_id,
				GS.team_id,
				GOAL.match_id,
				SUM(CASE 
					WHEN GOAL.own_goal = 0 AND GOAL.team_id = GOAL.player_team_id THEN 1  -- Team scores
					WHEN GOAL.own_goal = 1 AND GOAL.team_id <> GOAL.player_team_id THEN 1  -- Opponent scores due to own goal
					ELSE 0
				END) AS goals_for,
				SUM(CASE 
					WHEN GOAL.own_goal = 0 AND GOAL.team_id <> GOAL.player_team_id THEN 1  -- Opponent scores
					WHEN GOAL.own_goal = 1 AND GOAL.team_id = GOAL.player_team_id THEN 1  -- Own goal
					ELSE 0
				END) AS goals_against
			FROM
				(SELECT 
					M.match_id,
					M.tournament_id,
					M.home_team_id AS team_id,
					ME.player_id,
					ME.team_id AS 'player_team_id',
					G.own_goal
				FROM 
					 WC.match AS M
				INNER JOIN 
					 WC.match_event AS ME ON M.match_id = ME.match_id
				INNER JOIN 
					 WC.goal AS G ON ME.event_id = G.event_id
            
				UNION ALL
            
				SELECT 
					M.match_id,
					M.tournament_id,
					M.away_team_id AS team_id,
					ME.player_id,
					ME.team_id AS 'player_team_id',
					G.own_goal
				FROM 
					 WC.match AS M
				INNER JOIN 
					 WC.match_event AS ME ON M.match_id = ME.match_id
				INNER JOIN 
					 WC.goal AS G ON ME.event_id = G.event_id) AS GOAL
			INNER JOIN 
				 WC.group_standing AS GS ON 
				GOAL.tournament_id = GS.tournament_id 
				AND GOAL.team_id = GS.team_id
			GROUP BY
				GS.tournament_id,
				GS.team_id,
				GOAL.match_id
			HAVING CAST(SUBSTRING(GOAL.match_id, 8, 9) AS int) < 49 ) AS TEMP
		GROUP BY TEMP.tournament_id, TEMP.team_id;

    -- Update the group_standing table using data from the temporary table
    UPDATE GS
    SET 
        GS.goals_for = COALESCE(TEMP.goals_for, 0),
        GS.goals_against = COALESCE(TEMP.goals_against, 0)
		--, GS.goals_difference = COALESCE(TEMP.goals_for, 0) - COALESCE(TEMP.goals_against, 0)
    FROM 
         WC.group_standing AS GS
    INNER JOIN 
        #TempGroupGoals AS TEMP ON 
        GS.tournament_id = TEMP.tournament_id 
        AND GS.team_id = TEMP.team_id;

    -- Drop the temporary table after use
    DROP TABLE #TempGroupGoals;

    -- Insert aggregated goal data into the temporary table
    INSERT INTO #TempTeamGoals (tournament_id, team_id, goals_for, goals_against)
	SELECT 
		TEMP.tournament_id, 
		TEMP.team_id, 
		SUM(TEMP.goals_for), 
		SUM(TEMP.goals_against)
	FROM (	SELECT
				GS.tournament_id,
				GS.team_id,
				GOAL.match_id,
				SUM(CASE 
					WHEN GOAL.own_goal = 0 AND GOAL.team_id = GOAL.player_team_id THEN 1  -- Team scores
					WHEN GOAL.own_goal = 1 AND GOAL.team_id <> GOAL.player_team_id THEN 1  -- Opponent scores due to own goal
					ELSE 0
				END) AS goals_for,
				SUM(CASE 
					WHEN GOAL.own_goal = 0 AND GOAL.team_id <> GOAL.player_team_id THEN 1  -- Opponent scores
					WHEN GOAL.own_goal = 1 AND GOAL.team_id = GOAL.player_team_id THEN 1  -- Own goal
					ELSE 0
				END) AS goals_against
			FROM
				(SELECT 
					M.match_id,
					M.tournament_id,
					M.home_team_id AS team_id,
					ME.player_id,
					ME.team_id AS 'player_team_id',
					G.own_goal
				FROM 
					 WC.match AS M
				INNER JOIN 
					 WC.match_event AS ME ON M.match_id = ME.match_id
				INNER JOIN 
					 WC.goal AS G ON ME.event_id = G.event_id
            
				UNION ALL
            
				SELECT 
					M.match_id,
					M.tournament_id,
					M.away_team_id AS team_id,
					ME.player_id,
					ME.team_id AS 'player_team_id',
					G.own_goal
				FROM 
					 WC.match AS M
				INNER JOIN 
					 WC.match_event AS ME ON M.match_id = ME.match_id
				INNER JOIN 
					 WC.goal AS G ON ME.event_id = G.event_id) AS GOAL
			INNER JOIN 
				 WC.team_statistics AS GS ON 
				GOAL.tournament_id = GS.tournament_id 
				AND GOAL.team_id = GS.team_id
			GROUP BY
				GS.tournament_id,
				GS.team_id,
				GOAL.match_id ) AS TEMP
		GROUP BY TEMP.tournament_id, TEMP.team_id;

    -- Update the team_statistic table using data from the temporary table
    UPDATE GS
    SET 
        GS.goals = COALESCE(TEMP.goals_for, 0),
        GS.goals_against = COALESCE(TEMP.goals_against, 0)
    FROM 
         WC.team_statistics AS GS
    INNER JOIN 
        #TempTeamGoals AS TEMP ON 
        GS.tournament_id = TEMP.tournament_id 
        AND GS.team_id = TEMP.team_id;

    -- Drop the temporary table after use
    DROP TABLE #TempTeamGoals;

    -- Insert aggregated goal data into the temporary table
    INSERT INTO #TempPlayerGoals (tournament_id, player_id, goals_for)
	SELECT 
	TEMP.tournament_id,
	TEMP.player_id,
	SUM(TEMP.goal)
	FROM
		(SELECT 
			M.tournament_id,
			M.match_id,
			ME.player_id,
			SUM(CASE WHEN G.own_goal = 0 THEN 1 ELSE 0 END) AS 'goal'
		FROM
			 WC.match AS M
		INNER JOIN
			 WC.match_event AS ME
		ON	
			M.match_id = ME.match_id
		INNER JOIN 
			 WC.goal AS G
		ON
			ME.event_id = G.event_id
		GROUP BY
			M.tournament_id,
			M.match_id,
			ME.player_id ) AS TEMP
	GROUP BY
		TEMP.tournament_id,
		TEMP.player_id;

    -- Update the team_statistic table using data from the temporary table
    UPDATE GS
    SET 
        GS.goals = COALESCE(TEMP.goals_for, 0)
    FROM 
         WC.player_statistics AS GS
    INNER JOIN 
        #TempPlayerGoals AS TEMP ON 
        GS.tournament_id = TEMP.tournament_id 
        AND GS.player_id = TEMP.player_id;

    -- Drop the temporary table after use
    DROP TABLE #TempPlayerGoals;
END;
GO

CREATE TRIGGER trg_update_group_standing
ON  WC.group_standing
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	BEGIN TRY
		-- Declare a temporary table to hold intermediate results
		CREATE TABLE #TempGoals (
		    tournament_id NVARCHAR(100),
		    team_id NVARCHAR(100),
		    played INT
		);
		-- Insert aggregated goal data into the temporary table
		INSERT INTO #TempGoals (tournament_id, team_id, played)
		SELECT 
			TEMP.tournament_id
			, TEMP.team_id
			, COUNT(TEMP.match_id) AS played
		FROM 
			(SELECT 
				tournament_id, home_team_id AS team_id, match_id, stage_id
			FROM  WC.match 
			WHERE stage_id = 1
			UNION
			SELECT tournament_id, away_team_id AS team_id, match_id, stage_id
			FROM  WC.match 
			WHERE stage_id = 1 ) AS TEMP
		GROUP BY
			TEMP.tournament_id,
			TEMP.team_id;

		-- Update the team_statistic table using data from the temporary table
		UPDATE GS
		SET 
		    GS.played = COALESCE(TEMP.played, 0)
		FROM 
		     WC.group_standing AS GS
		INNER JOIN 
		    #TempGoals AS TEMP ON 
		    GS.tournament_id = TEMP.tournament_id 
		    AND GS.team_id = TEMP.team_id;

		-- Drop the temporary table after use
		DROP TABLE #TempGoals;

		-- Declare a temporary table to hold intermediate results
		CREATE TABLE #TempWDL (
		    tournament_id NVARCHAR(100),
		    team_id NVARCHAR(100),
		    wins INT,
			draws INT,
			losses INT
		);
		-- Insert aggregated goal data into the temporary table
		INSERT INTO #TempWDL (tournament_id, team_id, wins, draws, losses)
		SELECT TEMP.tournament_id, TEMP.team_id, TEMP.wins, TEMP.draws, TEMP.losses
		FROM
		(	SELECT 
			M.tournament_id,
			M.stage_id,
			team.team_id,
			team.team_name,  -- Assuming team_name exists in WC.team
			SUM(CASE 
				WHEN home_team_id = team.team_id AND home_team_win = 1 THEN 1 
				WHEN away_team_id = team.team_id AND away_team_win = 1 THEN 1 
				ELSE 0 
			END) AS wins,
			SUM(CASE 
				WHEN (home_team_id = team.team_id OR away_team_id = team.team_id) AND draw = 1 THEN 1 
				ELSE 0 
			END) AS draws,
			SUM(CASE 
				WHEN home_team_id = team.team_id AND away_team_win = 1 THEN 1 
				WHEN away_team_id = team.team_id AND home_team_win = 1 THEN 1 
				ELSE 0 
			END) AS losses
		
		FROM WC.[match] AS M
		JOIN WC.team team ON team.team_id IN (home_team_id, away_team_id)
		GROUP BY M.tournament_id, M.stage_id, team.team_id, team.team_name
		HAVING M.stage_id = 1) AS TEMP

		-- Update the team_statistic table using data from the temporary table
		UPDATE GS
		SET 
		    GS.wins = TEMP.wins,
		    GS.draws = TEMP.draws,
		    GS.losses = TEMP.losses
		FROM 
		     WC.group_standing AS GS
		INNER JOIN 
		    #TempWDL AS TEMP ON 
		    GS.tournament_id = TEMP.tournament_id 
		    AND GS.team_id = TEMP.team_id;

		-- Drop the temporary table after use
		DROP TABLE #TempWDL;


		    
        -- Temporary table for #TempGroupStandingPosition
        CREATE TABLE #TempGroupStandingPosition (
            tournament_id NVARCHAR(100),
            group_id NVARCHAR(100),
            team_id NVARCHAR(100),
            posititon INT,
			advanced BIT
        );

        -- Insert top scorer (Golden Ball) details
        INSERT INTO #TempGroupStandingPosition (tournament_id, group_id, team_id, posititon, advanced)
		SELECT 
			tournament_id,
			group_id,
			team_id,
			position,
			CASE WHEN position <= 2 THEN 1 ELSE 0 END AS advanced
		FROM (
			SELECT
				tournament_id,
				group_id,
				team_id,
				points,
				goals_difference,
				goals_for,
				ROW_NUMBER() OVER (
					PARTITION BY tournament_id, group_id 
					ORDER BY points DESC, goals_difference DESC, goals_for DESC, fair_play_points DESC
				) AS position
			FROM 
				WC.group_standing
		) AS TEMP


        -- Update group_standing
        UPDATE GS
        SET 
            GS.position = TEMP.posititon,
            GS.advanced = TEMP.advanced
        FROM 
            WC.group_standing AS GS
        INNER JOIN #TempGroupStandingPosition AS TEMP 
            ON GS.tournament_id = TEMP.tournament_id 
            AND GS.group_id = TEMP.group_id
			AND GS.team_id = TEMP.team_id;

        DROP TABLE #TempGroupStandingPosition;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE TRIGGER trg_update_team_statistic
ON  WC.team_statistics
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Use try-catch for error handling
    BEGIN TRY
        -- Declare a temporary table to hold intermediate results
        CREATE TABLE #TempWDL (
            tournament_id NVARCHAR(100),
            team_id NVARCHAR(100),
            wins INT,
            draws INT,
            losses INT
        );
        
        -- Insert aggregated win, draw, loss data into the temporary table
        INSERT INTO #TempWDL (tournament_id, team_id, wins, draws, losses)
        SELECT TEMP.tournament_id, TEMP.team_id, TEMP.wins, TEMP.draws, TEMP.losses
        FROM
        (
            SELECT 
                M.tournament_id,
                team.team_id,
                team.team_name,  -- Assuming team_name exists in WC.team
                SUM(CASE 
                    WHEN home_team_id = team.team_id AND home_team_win = 1 THEN 1 
                    WHEN away_team_id = team.team_id AND away_team_win = 1 THEN 1 
                    ELSE 0 
                END) AS wins,
                SUM(CASE 
                    WHEN (home_team_id = team.team_id OR away_team_id = team.team_id) AND draw = 1 THEN 1 
                    ELSE 0 
                END) AS draws,
                SUM(CASE 
                    WHEN home_team_id = team.team_id AND away_team_win = 1 THEN 1 
                    WHEN away_team_id = team.team_id AND home_team_win = 1 THEN 1 
                    ELSE 0 
                END) AS losses
            FROM WC.[match] AS M
            JOIN WC.team team ON team.team_id IN (home_team_id, away_team_id)
            GROUP BY M.tournament_id, team.team_id, team.team_name
        ) AS TEMP;

        -- Update the team_statistic table using data from the temporary table
        UPDATE GS
        SET 
            GS.wins = TEMP.wins,
            GS.draws = TEMP.draws,
            GS.losses = TEMP.losses
        FROM 
             WC.team_statistics AS GS
        INNER JOIN 
            #TempWDL AS TEMP ON 
            GS.tournament_id = TEMP.tournament_id 
            AND GS.team_id = TEMP.team_id;

        -- Drop the temporary table after use
        DROP TABLE #TempWDL;
		    -- Create temporary table for storing performance data
		CREATE TABLE #TempPerformance (
			tournament_id NVARCHAR(100),
			team_id NVARCHAR(100),
			stage_id INT,
			performance NVARCHAR(100)
		);

		-- Insert performance data into #TempPerformance for new matches only
		INSERT INTO #TempPerformance (tournament_id, team_id, stage_id, performance)
		SELECT 
			MS.tournament_id,
			MS.team_id,
			MS.stage_id,
			TS.stage_name
		FROM 
			(
			 SELECT 
				M.tournament_id,
				M.team_id,
				MAX(M.stage_id) AS stage_id
			FROM (
				SELECT tournament_id, match_id, stage_id, home_team_id AS team_id
				FROM  WC.match
				UNION ALL
				SELECT tournament_id, match_id, stage_id, away_team_id AS team_id
				FROM  WC.match
			) AS M
			GROUP BY M.tournament_id, M.team_id) AS MS
		INNER JOIN 
			 WC.tournament_stage AS TS
			ON MS.tournament_id = TS.tournament_id 
			AND MS.stage_id = TS.stage_id
		ORDER BY 
			MS.stage_id DESC;

		-- Update team_statistics table with the performance data from #TempPerformance
		UPDATE GS
		SET GS.performance = TEMP.performance
		FROM WC.team_statistics AS GS
		INNER JOIN #TempPerformance AS TEMP
			ON GS.tournament_id = TEMP.tournament_id 
			AND GS.team_id = TEMP.team_id
			AND (GS.performance IS NULL OR GS.performance <> TEMP.performance);

		-- Clean up the temporary table
		DROP TABLE #TempPerformance
    END TRY
    BEGIN CATCH
        -- Error handling: Print the error message
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

--- 
CREATE TRIGGER trg_update_statistic_table_booking_attributes
ON  WC.booking
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Use try-catch for error handling
    BEGIN TRY
		
        -- Declare a temporary table to hold card statistics
        CREATE TABLE #TempTeamCard (
            tournament_id NVARCHAR(100),
            team_id NVARCHAR(100),
            yellow_cards INT,
            red_cards INT
        );
        
        -- Insert aggregated yellow and red card data into the temporary table
        INSERT INTO #TempTeamCard  (tournament_id, team_id, yellow_cards, red_cards)
        SELECT 
            TEMP.tournament_id,
            TEMP.team_id,
            SUM(TEMP.y) AS yellow_cards,
            SUM(TEMP.r) AS red_cards
        FROM 
        (
            SELECT 
                M.tournament_id,
                M.match_id,
                ME.team_id,
                SUM(CASE WHEN B.yellow_card = 1 THEN 1 ELSE 0 END) AS y,
                SUM(CASE WHEN B.red_card = 1 THEN 1 ELSE 0 END) AS r
            FROM 
                 WC.[match] AS M
            INNER JOIN 
                 WC.match_event AS ME
            ON M.match_id = ME.match_id
            INNER JOIN
                 WC.booking AS B
            ON ME.event_id = B.event_id
            GROUP BY M.tournament_id, M.match_id, ME.team_id
        ) AS TEMP
        GROUP BY TEMP.tournament_id, TEMP.team_id;

        -- Update the team_statistic table with yellow and red card data
        UPDATE GS
        SET 
            GS.yellow_cards = TEMP.yellow_cards,
            GS.red_cards = TEMP.red_cards
        FROM 
             WC.team_statistics AS GS
        INNER JOIN 
            #TempTeamCard AS TEMP ON 
            GS.tournament_id = TEMP.tournament_id 
            AND GS.team_id = TEMP.team_id;

        -- Drop the temporary table after use
        DROP TABLE #TempTeamCard;

        -- Declare a temporary table to hold card statistics
        CREATE TABLE #TempPlayerCard (
            tournament_id NVARCHAR(100),
            player_id NVARCHAR(100),
            yellow_cards INT,
            red_cards INT,
			sent_offs INT
        );
        
        -- Insert aggregated yellow and red card data into the temporary table
        INSERT INTO #TempPlayerCard (tournament_id, player_id, yellow_cards, red_cards, sent_offs)
        SELECT 
            TEMP.tournament_id
            , TEMP.player_id
            , SUM(TEMP.y) AS yellow_cards
            , SUM(TEMP.r) AS red_cards
            , SUM(TEMP.s) AS sent_offs
        FROM 
        (
            SELECT 
                M.tournament_id
                , M.match_id
                , ME.player_id
                , SUM(CASE WHEN B.yellow_card = 1 THEN 1 ELSE 0 END) AS y
                , SUM(CASE WHEN B.red_card = 1 THEN 1 ELSE 0 END) AS r
				, SUM(CASE WHEN B.sent_off = 1 THEN 1 ELSE 0 END) AS s
            FROM 
                 WC.[match] AS M
            INNER JOIN 
                 WC.match_event AS ME
            ON M.match_id = ME.match_id
            INNER JOIN
                 WC.booking AS B
            ON ME.event_id = B.event_id
            GROUP BY M.tournament_id, M.match_id, ME.player_id
        ) AS TEMP
        GROUP BY TEMP.tournament_id, TEMP.player_id;

        -- Update the team_statistic table with yellow and red card data
        UPDATE GS
        SET 
            GS.yellow_cards = TEMP.yellow_cards
            , GS.red_cards = TEMP.red_cards
            , GS.sent_offs = TEMP.sent_offs
        FROM 
             WC.player_statistics AS GS
        INNER JOIN 
            #TempPlayerCard AS TEMP 
		ON 
            GS.tournament_id = TEMP.tournament_id 
            AND GS.player_id = TEMP.player_id;

        -- Drop the temporary table after use
        DROP TABLE #TempPlayerCard;
        
				-- Temporary table for #TempFairPlay
        CREATE TABLE #TempFairPlay (
            tournament_id NVARCHAR(100),
            group_id NVARCHAR(100),
			stage_id INT,
            team_id NVARCHAR(100),
            fair_play_points INT
        );

        -- Insert top scorer (Golden Ball) details
        INSERT INTO #TempFairPlay (tournament_id, group_id, stage_id, team_id, fair_play_points)
		SELECT 
			TEMP.tournament_id,
			TEMP.group_id,
			TEMP.stage_id,
			TEMP.team_id,
			SUM(fair_play_points) AS fair_play_points
		FROM (SELECT 
			M.tournament_id,
			M.group_id,
			M.stage_id,
			M.match_id,
			ME.team_id,
			SUM(
				CASE 
					WHEN B.yellow_card = 1 AND B.second_yellow_card = 0 AND B.red_card = 0 THEN -1
					WHEN B.yellow_card = 1 AND B.second_yellow_card = 1 THEN -3
					WHEN B.yellow_card = 0 AND B.red_card = 1 THEN -4
					WHEN B.yellow_card = 1 AND B.red_card = 1 THEN -5
					ELSE 0
				END
			) AS fair_play_points
		FROM 
			 WC.[match] AS M
		INNER JOIN 
			 WC.[match_event] AS ME ON M.match_id = ME.match_id
		INNER JOIN 
			 WC.booking AS B ON ME.event_id = B.event_id
		GROUP BY 
			M.tournament_id,
			M.group_id,
			M.stage_id,
			M.match_id,
			ME.team_id
		HAVING
			M.stage_id = 1  ) AS TEMP
		GROUP BY 
			TEMP.tournament_id,
			TEMP.group_id,
			TEMP.stage_id,
			TEMP.team_id;


        -- Update group_standing
        UPDATE GS
        SET 
            GS.fair_play_points = TEMP.fair_play_points
        FROM 
            WC.group_standing AS GS
        INNER JOIN #TempFairPlay AS TEMP 
            ON GS.tournament_id = TEMP.tournament_id 
            AND GS.group_id = TEMP.group_id
			AND GS.stage_id = TEMP.stage_id
			AND GS.team_id = TEMP.team_id;

        DROP TABLE #TempFairPlay;
    END TRY
    BEGIN CATCH
        -- Error handling: Print the error message
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE TRIGGER trg_insert_tournament_standing
ON WC.[match]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Use MERGE to insert or update tournament_standing based on the results of matches
    MERGE INTO WC.tournament_standing AS target
    USING (
        SELECT 
            tournament_id,
            CASE WHEN home_team_win = 1 THEN home_team_id ELSE away_team_id END AS team_id,
            CASE 
                WHEN stage_id = 6 THEN 1  -- Winner of the final
                WHEN stage_id = 5 THEN 3  -- Winner of the third-place match
            END AS position
        FROM WC.[match]
        WHERE stage_id IN (5, 6)
		UNION 
		SELECT 
            tournament_id,
            CASE WHEN home_team_win = 1 THEN away_team_id ELSE home_team_id END AS team_id,
            CASE 
                WHEN stage_id = 6 THEN 2  -- Winner of the final
                WHEN stage_id = 5 THEN 4  -- Winner of the third-place match
            END AS position
        FROM WC.[match]
        WHERE stage_id IN (5, 6)
    ) AS source
    ON target.tournament_id = source.tournament_id AND target.team_id = source.team_id
    
    WHEN MATCHED THEN 
        UPDATE SET target.position = source.position  -- Update position if the record exists
    WHEN NOT MATCHED THEN 
        INSERT (tournament_id, team_id, position) 
        VALUES (source.tournament_id, source.team_id, source.position);  -- Insert new record

END;
GO


CREATE TRIGGER trg_insert_award_winner
ON WC.award -- Replace with your target table
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert only if the record does not already exist
    INSERT INTO WC.award_winner (tournament_id, award_id)
    SELECT 
        T.tournament_id, 
        i.award_id
    FROM inserted i
	CROSS JOIN  WC.tournament AS T
    WHERE NOT EXISTS (
        SELECT 1
        FROM WC.award_winner aw
        WHERE aw.tournament_id = T.tournament_id
        AND aw.award_id = i.award_id
    );
END;
GO

CREATE TRIGGER trg_update_award_winner_golden_sivler_bronze_boot
ON WC.player_statistics
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Temporary table for Golden Ball
        CREATE TABLE #TempGoldenSilverBronze (
            tournament_id NVARCHAR(100),
            award_id NVARCHAR(100),
            team_id NVARCHAR(100),
            player_id NVARCHAR(100)
        );

        -- Insert top scorer (Golden Ball) details
        INSERT INTO #TempGoldenSilverBronze (tournament_id, award_id, team_id, player_id)
        SELECT 
            ts.tournament_id,
            A.award_id,
            S.team_id,
            ts.player_id
        FROM 
            (SELECT 
                ps.tournament_id,
                ps.player_id,
                ROW_NUMBER() OVER (PARTITION BY ps.tournament_id ORDER BY ps.goals DESC) AS GoalRank
             FROM 
                WC.player_statistics ps
            ) ts
        INNER JOIN WC.award AS A 
            ON A.award_name = 'Golden Ball'
        INNER JOIN WC.squad AS S
            ON ts.tournament_id = S.tournament_id AND ts.player_id = S.player_id
        WHERE ts.GoalRank = 1;

		-- Insert 2nd top scorer (Silver Ball) details
        INSERT INTO #TempGoldenSilverBronze (tournament_id, award_id, team_id, player_id)
        SELECT 
            ts.tournament_id,
            A.award_id,
            S.team_id,
            ts.player_id
        FROM 
            (SELECT 
                ps.tournament_id,
                ps.player_id,
                ROW_NUMBER() OVER (PARTITION BY ps.tournament_id ORDER BY ps.goals DESC) AS GoalRank
             FROM 
                WC.player_statistics ps
            ) ts
        INNER JOIN WC.award AS A 
            ON A.award_name = 'Silver Boot'
        INNER JOIN WC.squad AS S
            ON ts.tournament_id = S.tournament_id AND ts.player_id = S.player_id
        WHERE ts.GoalRank = 2;

		-- Insert 3rd top scorer (Bronze Boot) details
        INSERT INTO #TempGoldenSilverBronze (tournament_id, award_id, team_id, player_id)
        SELECT 
            ts.tournament_id,
            A.award_id,
            S.team_id,
            ts.player_id
        FROM 
            (SELECT 
                ps.tournament_id,
                ps.player_id,
                ROW_NUMBER() OVER (PARTITION BY ps.tournament_id ORDER BY ps.goals DESC) AS GoalRank
             FROM 
                WC.player_statistics ps
            ) ts
        INNER JOIN WC.award AS A 
            ON A.award_name = 'Bronze Boot'
        INNER JOIN WC.squad AS S
            ON ts.tournament_id = S.tournament_id AND ts.player_id = S.player_id
        WHERE ts.GoalRank = 3;

        -- Update award_winner table for Golden Ball
        UPDATE AW
        SET 
            AW.team_id = TEMP.team_id,
            AW.player_id = TEMP.player_id
        FROM 
            WC.award_winner AS AW
        INNER JOIN #TempGoldenSilverBronze AS TEMP 
            ON AW.tournament_id = TEMP.tournament_id 
            AND AW.award_id = TEMP.award_id;

        DROP TABLE #TempGoldenSilverBronze;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO



CREATE TRIGGER trg_update_tournament_summary
ON WC.player_statistics
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Update count_matches in tournament_summary
    UPDATE WC.tournament_statistics
    SET count_matches = M.count_matches
    FROM (
        SELECT 
            tournament_id, 
            COUNT(match_id) AS count_matches
        FROM 
            WC.match
        GROUP BY 
            tournament_id
    ) AS M
    WHERE WC.tournament_statistics.tournament_id = M.tournament_id;

    -- Update count_teams in tournament_summary
    UPDATE WC.tournament_statistics
    SET count_teams = T.count_teams
    FROM (
        SELECT 
            tournament_id, 
            COUNT(DISTINCT team_id) AS count_teams
        FROM 
            WC.squad
        GROUP BY 
            tournament_id
    ) AS T
    WHERE WC.tournament_statistics.tournament_id = T.tournament_id;

    -- Update goals, yellow_cards, and red_cards in tournament_summary
    UPDATE WC.tournament_statistics
    SET 
        goals = TS.goals,
        yellow_cards = TS.yellow_cards,
        red_cards = TS.red_cards
    FROM (
        SELECT 
            tournament_id,
            SUM(goals) AS goals,
            SUM(yellow_cards) AS yellow_cards,
            SUM(red_cards) AS red_cards
        FROM 
            WC.team_statistics
        GROUP BY 
            tournament_id
    ) AS TS
    WHERE WC.tournament_statistics.tournament_id = TS.tournament_id;

    -- Update sent_off in tournament_summary
    UPDATE WC.tournament_statistics 
    SET sent_offs = PS.sent_off
    FROM (
        SELECT 
            tournament_id,
            SUM(sent_offs) AS sent_off
        FROM 
            WC.player_statistics
        GROUP BY 
            tournament_id
    ) AS PS
    WHERE WC.tournament_statistics.tournament_id = PS.tournament_id;

END;
GO


CREATE OR ALTER TRIGGER trg_update_best_goalkeeper
ON  WC.goal
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- Step 1: Calculate matches played and goals conceded for each goalkeeper
    DROP TABLE IF EXISTS #tmp_test1, #tmp_test2;

    SELECT 
        M.tournament_id,
        PA.player_id,
        COUNT(DISTINCT M.match_id) AS matches, -- Count distinct matches played by the goalkeeper
        SUM(CASE 
            WHEN ME.team_id = S.team_id AND G.own_goal = 0 THEN 0 -- Non-own goal by the goalkeeper's team
            WHEN ME.team_id = S.team_id AND G.own_goal = 1 THEN 1 -- Own goal by the goalkeeper's team
            WHEN ME.team_id <> S.team_id AND G.own_goal = 0 THEN 1 -- Non-own goal by opponent (conceded)
            WHEN ME.team_id <> S.team_id AND G.own_goal = 1 THEN 0 -- Own goal by opponent (not counted against)
        END) AS concedes -- Total goals conceded by the goalkeeper
    INTO #tmp_test1
    FROM 
         WC.match_event AS ME
    INNER JOIN 
         WC.[match] AS M ON ME.match_id = M.match_id
    INNER JOIN 
         WC.goal AS G ON ME.event_id = G.event_id
    INNER JOIN 
         WC.player_appearance AS PA ON PA.match_id = M.match_id
    INNER JOIN 
         WC.squad AS S ON PA.player_id = S.player_id AND M.tournament_id = S.tournament_id
    WHERE  
        PA.position_id = 'GK' -- Filtering for goalkeepers
    GROUP BY 
        M.tournament_id,
        PA.player_id;

    -- Step 2: Find max matches for each concede level
    WITH MAX_MATCH AS (
        SELECT 
            tournament_id,
            concedes, 
            MAX(matches) AS max_matches
        FROM 
            #tmp_test1
        GROUP BY 
            tournament_id,
            concedes
    )
    SELECT 
        tournament_id,
        max_matches, 
        MIN(concedes) AS min_concedes
    INTO #tmp_test2
    FROM 
        MAX_MATCH
    GROUP BY 
        tournament_id,
        max_matches;

    -- Step 3: Update award_winner table with the goalkeepers having max matches and min concedes
    DELETE FROM  WC.award_winner
    WHERE award_id = 'A-7'; -- Remove previous entries for the clean sheet award

    INSERT INTO  WC.award_winner (tournament_id, team_id, player_id, award_id)
    SELECT 
        CLEAN_SHEET.tournament_id,
        S.team_id,
        CLEAN_SHEET.player_id,
        'A-7' -- Clean sheet award ID
    FROM 
        (SELECT 
            t1.*,
            ROW_NUMBER() OVER(PARTITION BY t1.tournament_id ORDER BY t2.max_matches DESC) AS RN
         FROM 
            #tmp_test1 AS t1
         INNER JOIN 
            #tmp_test2 AS t2 ON t1.matches = t2.max_matches
            AND t1.concedes = t2.min_concedes
        ) AS CLEAN_SHEET
    INNER JOIN 
         WC.squad AS S ON CLEAN_SHEET.tournament_id = S.tournament_id AND CLEAN_SHEET.player_id = S.player_id
    WHERE 
        CLEAN_SHEET.RN = 1; -- Only insert the top goalkeeper per tournament

    -- Cleanup temporary tables
    DROP TABLE IF EXISTS #tmp_test1, #tmp_test2;
END;
GO





-- INSERT DATA 
-- COUNTRY data
INSERT INTO WC.country 
			(country_code, country_name)
SELECT DISTINCT team_code, team_name
FROM (
SELECT team_code, team_name
FROM messy_CVS.dbo.team_appearances
UNION
SELECT home_team_code AS 'team_code', home_team_name AS 'team_name'
FROM messy_CVS.dbo.matches
UNION
SELECT away_team_code AS 'team_code', away_team_name AS 'team_name'
FROM messy_CVS.dbo.matches
) AS A
INSERT INTO WC.country 
			(country_code, country_name)
VALUES (N'NOR',N'Norway');
GO

------------------ CITY DATA ------------------
INSERT INTO WC.city
			(city_name, country_code)
SELECT DISTINCT A.city_name, C.country_code
FROM 
(
	SELECT DISTINCT * 
	FROM (SELECT DISTINCT city_name, country_name FROM messy_CVS.dbo.matches) AS A
	UNION
	SELECT *
	FROM (SELECT city_name, country_name FROM messy_CVS.dbo.stadiums) AS B
	UNION
	SELECT *
	FROM (SELECT DISTINCT city_name, country_name FROM messy_CVS.dbo.team_appearances) AS C
) AS A
INNER JOIN 
	WC.country AS C
ON
	A.country_name = C.country_name;
GO

------------------ STADIUM DATA ------------------
INSERT INTO WC.stadium
			(stadium_id, stadium_name, stadium_wikipedia_link, capacity, city_id)
SELECT S.stadium_id, S.stadium_name, S.stadium_wikipedia_link, S.stadium_capacity, city_id
FROM messy_CVS.dbo.stadiums AS S
INNER JOIN WC.city AS C
ON S.city_name = C.city_name;
GO

------------------ CONFEDERATION DATA ------------------
INSERT INTO WC.confederation
			(confederation_id, confederation_name, confederation_code, confederation_wikipedia_code)
SELECT confederation_id, confederation_name, confederation_code, confederation_wikipedia_link
FROM messy_CVS.dbo.confederations;
GO

------------------ TOURNAMENT DATA ------------------
INSERT INTO WC.tournament
			(tournament_id,tournament_name,year,start_date,end_date,host_won)
SELECT tournament_id,tournament_name,year,start_date,end_date,host_won
FROM messy_CVS.dbo.tournaments;
GO

------------------ AWARD DATA ------------------
INSERT INTO WC.award
			(award_id, award_name, award_description, year_introduce)
SELECT award_id, award_name, award_description, year_introduced           
FROM messy_CVS.dbo.awards
WHERE award_name IN (N'Golden Ball', N'Silver Boot', N'Bronze Boot', N'Golden Glove');
INSERT INTO WC.award
			(award_id, award_name, award_description, year_introduce)
VALUES (N'A-9', N'Fair Play', N'best record of fair play', 2024);
GO

------------------ HOST COUNTRY DATA ------------------
INSERT INTO WC.host_country
			(country_code, tournament_id)
SELECT team_code, tournament_id
FROM messy_CVS.dbo.host_countries;
GO

------------------ GROUP DATA ------------------
INSERT INTO WC.[group] (group_id, group_name)
SELECT DISTINCT 
    'GRP_' + SUBSTRING(group_name, LEN(group_name), 1) AS group_id, 
    group_name
FROM messy_CVS.DBO.groups;
GO

------------------ TEAM DATA ------------------
INSERT INTO WC.team
			(team_id, team_name, team_code, men_team, women_team, federation_name, men_wikipedia_link, women_wikipedia_link, federation_wikipedia_link, confederation_id)
SELECT team_id, team_name, team_code, mens_team, womens_team, federation_name, mens_team_wikipedia_link, womens_team_wikipedia_link, federation_wikipedia_link, confederation_id
FROM messy_CVS.dbo.teams;
GO

------------------ MANAGER DATA ------------------
INSERT INTO WC.manager
			(manager_id, given_name, family_name, female, manager_wikipedia_link, country_code)
SELECT M.manager_id, M.given_name, M.family_name, M.female, M.manager_wikipedia_link, C.country_code
FROM messy_CVS.dbo.managers AS M
INNER JOIN WC.country AS C
ON M.country_name = C.country_name;
GO

------------------ REFEREE data - HAVING COUNTRY CODE ------------------
INSERT INTO WC.referee
			(referee_id, given_name, family_name, female, referee_wikipedia_link, confederation_id, country_code)
SELECT R.referee_id, R.given_name, R.family_name, R.female, R.referee_wikipedia_link, R.confederation_id, C.country_code
FROM messy_CVS.dbo.referees AS R
INNER JOIN WC.country AS C
ON R.country_name = C.country_name;
GO

------------------ REFEREE DATA - NOT HAVING COUNTRY CODE ------------------
INSERT INTO WC.referee
			(referee_id, given_name, family_name, female, referee_wikipedia_link, confederation_id)
SELECT R.referee_id, R.given_name, R.family_name, R.female, R.referee_wikipedia_link, R.confederation_id
FROM messy_CVS.dbo.referees AS R
EXCEPT
SELECT R_new.referee_id, R_new.given_name, R_new.family_name, R_new.female, R_new.referee_wikipedia_link, R_new.confederation_id
FROM WC.referee R_new;
GO

------------------ PLAYER DATA ------------------
INSERT INTO WC.player
			(player_id, given_name, family_name, birth_date, female, player_wikipedia_link, country_code)
SELECT DISTINCT P.player_id, P.given_name, P.family_name, P.birth_date, P.female, P.player_wikipedia_link, T.team_code
FROM WC.team AS T
INNER JOIN messy_CVS.dbo.squads AS S
ON T.team_id = S.team_id
INNER JOIN messy_CVS.dbo.players AS P
ON S.player_id = P.player_id;
GO

------------------ TOURNAMENT STAGE DATA ------------------
INSERT INTO WC.tournament_stage
		(stage_id, tournament_id, stage_name, group_stage,  knockout_stage, start_date, end_date)
SELECT stage_number, tournament_id, stage_name, group_stage, knockout_stage, start_date, end_date
FROM messy_CVS.dbo.tournament_stages;
GO

------------------ POSITION DATA ------------------
INSERT INTO WC.position
			(position_id, position_name)
SELECT position_code, position_name
FROM messy_CVS.DBO.squads
UNION
SELECT position_code, position_name
FROM messy_CVS.DBO.player_appearances;
GO

------------------ SQUAD DATA ------------------
INSERT INTO WC.squad
		(player_id, tournament_id, team_id, position_id, shirt_number)
SELECT player_id, tournament_id, team_id, position_code, shirt_number
FROM messy_CVS.DBO.squads;
GO

------------------ REFEREE APPOINTMENT DATA ------------------
INSERT INTO WC.referee_appointment
			(referee_id, tournament_id)
SELECT referee_id, tournament_id
FROM messy_CVS.DBO.referee_appointments
GO

------------------ MANAGER APPOINTMENT DATA ------------------
INSERT INTO WC.manager_appointment
			(manager_id, tournament_id, team_id)
SELECT manager_id, tournament_id, team_id
FROM messy_CVS.dbo.manager_appointments;
GO

------------------ MATCH DATA ------------------
INSERT INTO WC.[match]
			(match_id, match_name, tournament_id, stadium_id, home_team_id, away_team_id, stage_id, group_id, match_date, match_time, home_team_win, away_team_win, draw)
SELECT DISTINCT 
	M.match_id, M.match_name, M.tournament_id, 
	M.stadium_id, M.home_team_id, M.away_team_id, TS.stage_id,
	G.group_id, M.match_date, M.match_time, 
	M.home_team_win, M.away_team_win, M.draw
FROM 
	messy_CVS.DBO.matches AS M
LEFT JOIN 
	WC.[group] AS G
ON 
	M.group_name = G.group_name
LEFT JOIN 
	WC.tournament_stage AS TS
ON 
	M.stage_name = TS.stage_name;
GO

------------------ REFEREE APPEARANCE DATA ------------------
INSERT INTO WC.referee_appearance
			(referee_id, match_id)
SELECT referee_id, match_id
FROM messy_CVS.DBO.referee_appearances;
GO

------------------ MANAGER APPEARANCE DATA ------------------
INSERT INTO WC.manager_appearance
			(manager_id, match_id, team_id)
SELECT manager_id, match_id, team_id
FROM messy_CVS.DBO.manager_appearances;
GO

------------------ PLAYER APPEARANCE DATA ------------------
INSERT INTO WC.player_appearance
			(player_id, match_id, position_id, starter, substitute)
SELECT player_id, match_id, position_code, starter, substitute
FROM messy_CVS.DBO.player_appearances;
GO

------------------ EVENT TYPE DATA ------------------
INSERT INTO WC.event_type (event_type_id, event_name, description) VALUES 
(N'BOOKING', N'Booking', N'A player receiving a yellow or red card'),
(N'GOAL', N'Goal', N'A goal scored by a player.'),
(N'SUBSTITUTION', N'Substitution', N'A player is replaced by another player on the field.'),
(N'PENALTY_SHOOTOUT', N'Penalty Shootout',  N'A penalty shootout occurrence');
GO

-- INSERT DATA INTO GROUP_STANDING 
-- TODO: INSERT TEAM INTO GROUP STANDING
-- AS messy_CVS.dbo.group_standing team_id is missing team_id -> use WC.match table instead
INSERT INTO WC.group_standing
			(tournament_id, team_id, group_id, stage_id)
SELECT DISTINCT tournament_id, home_team_id AS team_id, group_id, stage_id
FROM WC.match AS M
WHERE stage_id = 1
UNION
SELECT DISTINCT tournament_id, away_team_id AS team_id, group_id, stage_id
FROM WC.match AS M
WHERE stage_id = 1
ORDER BY tournament_id, group_id
GO

------------------ GOAL ------------------ 
INSERT INTO WC.match_event (event_id, event_type_id, minute_regulation, minute_stoppage, match_id, team_id, player_id)
SELECT 
    G.match_id + '_GOAL_' + CAST(ROW_NUMBER() OVER (PARTITION BY G.match_id ORDER BY (SELECT NULL)) AS NVARCHAR(10)) AS event_id,
    'GOAL' AS event_type_id,
    G.minute_regulation,
    G.minute_stoppage,
    G.match_id,
	G.player_team_id,
	G.player_id
FROM messy_CVS.dbo.goals AS G
ORDER BY event_id

-- Insert data into WC.goal
INSERT INTO WC.goal(event_id, own_goal, is_penalty)
SELECT 
    G.match_id + '_GOAL_' + CAST(ROW_NUMBER() OVER (PARTITION BY G.match_id ORDER BY (SELECT NULL)) AS NVARCHAR(10)) AS event_id,
	G.own_goal,
    G.penalty
FROM messy_CVS.dbo.goals AS G
ORDER BY event_id;

------------------ BOOKING ------------------ 

INSERT INTO WC.match_event (event_id, event_type_id, minute_regulation, minute_stoppage, match_id, team_id, player_id)
SELECT 
    B.match_id + '_BOOKING_' + CAST(ROW_NUMBER() OVER (PARTITION BY B.match_id ORDER BY (SELECT NULL)) AS NVARCHAR(10)) AS event_id,
    'BOOKING' AS event_type_id,
    B.minute_regulation,
    B.minute_stoppage,
    B.match_id,
	B.team_id,
	B.player_id
FROM messy_CVS.dbo.bookings AS B
ORDER BY event_id

-- Insert data into WC.goal
INSERT INTO WC.booking(event_id, yellow_card, second_yellow_card, red_card, sent_off)
SELECT 
    B.match_id + '_BOOKING_' + CAST(ROW_NUMBER() OVER (PARTITION BY B.match_id ORDER BY (SELECT NULL)) AS NVARCHAR(10)) AS event_id,
	B.yellow_card,
	b.second_yellow_card,
    B.red_card,
	B.sending_off
FROM messy_CVS.dbo.bookings AS B

------------------ SUBSTITUTION ------------------
INSERT INTO WC.match_event (event_id, event_type_id, minute_regulation, minute_stoppage, match_id, team_id, player_id)
SELECT 
    S.match_id + '_SUBSTITUTION_' + CAST(ROW_NUMBER() OVER (PARTITION BY S.match_id ORDER BY (SELECT NULL)) AS NVARCHAR(10)) AS event_id,
    'SUBSTITUTION' AS event_type_id,
    S.minute_regulation,
    S.minute_stoppage,
    S.match_id,
	S.team_id,
	S.player_id
FROM messy_CVS.dbo.substitutions AS S
ORDER BY event_id;

-- Insert data into WC.goal
INSERT INTO WC.substitution(event_id, player_out, player_in)
SELECT 
	S.match_id + '_SUBSTITUTION_' + CAST(ROW_NUMBER() OVER (PARTITION BY S.match_id ORDER BY (SELECT NULL)) AS NVARCHAR(10)) AS event_id,
	S.going_off,
	S.coming_on
FROM messy_CVS.dbo.substitutions AS S
ORDER BY event_id;

-- PENALTY_SHOOTOUT ------------------------------------------
INSERT INTO WC.match_event (event_id, event_type_id, match_id, team_id, player_id)
SELECT 
    P.match_id + '_PENALTY_SHOOTOUT_' + CAST(ROW_NUMBER() OVER (PARTITION BY P.match_id ORDER BY (SELECT NULL)) AS NVARCHAR(10)) AS event_id,
    'PENALTY_SHOOTOUT' AS event_type_id,
    P.match_id,
	P.team_id,
	P.player_id
FROM messy_CVS.dbo.penalty_kicks AS P
ORDER BY event_id;

-- Insert data into WC.goal
INSERT INTO WC.penalty_shootout(event_id, converted)
SELECT 
    P.match_id + '_PENALTY_SHOOTOUT_' + CAST(ROW_NUMBER() OVER (PARTITION BY P.match_id ORDER BY (SELECT NULL)) AS NVARCHAR(10)) AS event_id,
    P.converted
FROM messy_CVS.dbo.penalty_kicks AS P
ORDER BY event_id;