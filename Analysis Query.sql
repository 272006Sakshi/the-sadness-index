-- ============================================================
-- Hindi Songs Mood Trend Analysis (2010-2024)
-- Database: PostgreSQL
-- Table: songs (2,374 rows — filtered to Hindi tracks, mood classified in Python)
-- ============================================================
 
-- 1. Basic sanity checks after import
SELECT COUNT(*) FROM songs;
 
SELECT * FROM songs LIMIT 5;
 
 
-- 2. Year-wise mood trend
-- Replicates the Python groupby result; used to cross-validate the analysis.
SELECT
    year,
    mood,
    COUNT(*) AS song_count
FROM songs
GROUP BY year, mood
ORDER BY year, mood;
 
 
-- 3. Top 10 saddest songs (lowest valence)
SELECT
    track_name,
    artist_name,
    valence
FROM songs
WHERE mood = 'Sad'
ORDER BY valence ASC
LIMIT 10;
 
 
-- 4. Top 10 most "party" songs (highest valence)
SELECT
    track_name,
    artist_name,
    valence
FROM songs
WHERE mood = 'Party'
ORDER BY valence DESC
LIMIT 10;
 
 
-- 5. Average audio features by mood category
-- Compares tempo, energy, and danceability across Sad / Neutral / Party songs.
SELECT
    mood,
    ROUND(AVG(tempo), 1)        AS avg_tempo,
    ROUND(AVG(energy), 2)       AS avg_energy,
    ROUND(AVG(danceability), 2) AS avg_danceability
FROM songs
GROUP BY mood
ORDER BY mood;
 
 
-- 6. Window function — dominant mood per year
-- Ranks moods within each year by song count.
SELECT
    year,
    mood,
    COUNT(*) AS cnt,
    RANK() OVER (PARTITION BY year ORDER BY COUNT(*) DESC) AS rank_in_year
FROM songs
GROUP BY year, mood
ORDER BY year, rank_in_year;
 
 
-- 7. Bonus — musical key (major/minor) vs mood
-- mode: 1 = major key, 0 = minor key
-- Hypothesis check: are minor-key songs more likely to be classified as "Sad"?
SELECT
    mode,
    mood,
    COUNT(*) AS song_count
FROM songs
GROUP BY mode, mood
ORDER BY mode, mood;
 
