# LastFM Clone written in Swift with Clean Architecture + Realm + MVVM + Combine + UIkit + Test

This is a clone of the LastFM public API. [https://www.last.fm/api]

The Project is based on Uncle Bob's Clean Architecture.

<img src="https://github.com/shayan-dnsh/LastFMClone/blob/master/ScreenShot/clean.png"/>

It has three main layers 
* Data (Network Data - Local data with Realm)
* Domain
* Presentation
  
and a **Core** component. 

Another part of the application is the **Test** module that is under development...

LastFM has public APIs that you can signup for and gets data about specific music, albums, artists, and more. So for the network data part of this application, these APIs have been used. 

The Project was developed by **Swift 5** and **Combine** as reactive part of it. there is no great UI/UX design on presentation layer. Any other UI can be placed instead of it. 

This project has four main features:
* Main page of media from network and database
* Get Media Details
* Favorite media detail locally
* Search medias

Also, It contains **Test Module** that is under development

<img src="https://github.com/shayan-dnsh/LastFMClone/blob/master/ScreenShot/media_detail.png"  height="844" width="390" />

## Domain
This layer contains **Repository Protocols**, **UseCases**, **Entities**    

## Data
This Layer include **Network Module**, **Data Sources**, **Repository Implementations**, **Storage**,
**Network Models**,

## Presentation(Sciene)
In this layer have been used **MVVM** for presentation and all UI components and protocols that are needed for communication with the domain layer are included.

## Core
General parts of the application are placed in this module. Some things like **DI**, **General Components**, **Combine Core**, and more and more. 

## Installation

Clone the project and run

## Development setup
The deployment target is 13.0


## Release History

* 1.0
    * Add project to the repository

## Meta

Shayan Amin Danespour – Twiiter: [https://twitter.com/s_aminDaneshpur](twitter.com/s_aminDaneshpur) – shayan.amindaneshpour@gmail.com

Github: [github.com/shayan-dnsh](github.com/shayan-dnsh)

## Contributing

1. Fork it (<https://github.com/yourname/yourproject/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request
