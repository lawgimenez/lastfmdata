package main

import "fmt"
import "net/http"
import "io/ioutil"
import "encoding/json"

func main() {
    response, error := http.Get("https://ws.audioscrobbler.com/2.0/?method=user.gettopalbums&user=xthekingisdeadx&api_key=90c9a564ff2f83029c1c7c97375059cd&format=json&period=7day")
    if error != nil {

    }
    defer response.Body.Close()
    body, error := ioutil.ReadAll(response.Body)
    // fmt.Println(string(body))

    var jsonResponse Response
    json.Unmarshal(body, &jsonResponse)

    var albums = jsonResponse.TopAlbums.Album
    for _, album := range albums {
        fmt.Println(album.Artist.Name, ":", album.PlayCount)
    }
}

type Response struct {
    TopAlbums TopAlbums `json:"topalbums"`
}

type TopAlbums struct {
    Album []Album `json:album`
}

type Album struct {
    Artist Artist `json:"artist"`
    Image []Image `json:"image"`
    PlayCount string
}

type Artist struct {
    ArtistUrl string `json:"url"`
    Name string
}

type Image struct {
    Size string `json:"size"`
    Text string `json:"#text"`
}