//
//  ScreenLoadingType.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/7/21.
//

/// Set loading and reloading application state
public enum ScreenLoadingType<Input> {
    case loading(Input)
    case reloading(Input)
}


