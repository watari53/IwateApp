UPDATE pictures
SET
      address = (SELECT albums.address 
                            FROM albums
                            WHERE albums.album_id = pictures.album_id )
WHERE
    EXISTS (
        SELECT *
        FROM albums
        WHERE albums.album_id = pictures.album_id
    );
