//
//  PagingInfo.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/9/21.
//

 /**
 This is an struct with generic model type to make easy to use pagination with models.
 Four way of initialazion defined for this model.
 
 - `PagingInfo` Used for set pagination infos of specific model
 
  */

public struct PagingInfo<T> {
    public var page: Int
    public var items: [T]
    public var hasMorePages: Bool
    public var totalItems: Int
    public var itemsPerPage: Int
    public var totalPages: Int

    // Normal initialization with all the parametes
    public init(page: Int,
                items: [T],
                hasMorePages: Bool,
                totalItems: Int,
                itemsPerPage: Int,
                totalPages: Int) {
        self.page = page
        self.items = items
        self.hasMorePages = hasMorePages
        self.totalItems = totalItems
        self.itemsPerPage = itemsPerPage
        self.totalPages = totalPages
    }
    
    // Object with page, items, has`MoreItems and no more infoes
    public init(page: Int, items: [T], hasMorePages: Bool) {
        self.init(page: page,
                  items: items,
                  hasMorePages: hasMorePages,
                  totalItems: 0,
                  itemsPerPage: 0,
                  totalPages: 0)
    }
    
    // Object with specify page and no more infoes
    public init(page: Int, items: [T]) {
        self.init(page: page,
                  items: items,
                  hasMorePages: true,
                  totalItems: 0,
                  itemsPerPage: 0,
                  totalPages: 0)
    }
    
    
    // Empty initialization with page 1
    public init() {
        self.init(page: 1,
                  items: [],
                  hasMorePages: true,
                  totalItems: 0,
                  itemsPerPage: 0,
                  totalPages: 0)
    }
}
