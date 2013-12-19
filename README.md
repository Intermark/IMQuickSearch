![Banner](https://raw.github.com/intermark/IMQuickSearch/master/Images/banner.png)

## About

IMQuickSearch is a tool for quickly filtering multiple NSArrays that contain a variety of custom NSObject classes. It takes any value, and is not limited purely by an NSString. You can filter an NSObject by an NSNumber if you so choose. However, since its primary focus is for quickly filtering objects, when you filter by an NSString it performs a contains search - searching for "Bo" returns "Bob" and "Bojangles."

## Installation

All of the important classes are located in the top-level directory <code>Classes</code>. The files you want to copy into your project are:

* <code>IMQuickSearch.{h,m}</code>
* <code>IMQuickSearchFilter.{h,m}</code>

Just <code>#import "IMQuickSearch.h"</code> in any class you want to use IMQuickSearch in.

**Cocoapods**

Cocoapods coming soon.

## Setting Up IMQuickSearch

To begin, you are going to want to have your NSArrays of NSObjects already populated and at your disposal. From here, you're going to create your IMQuickSearchFilter objects like so:

```objc
IMQuickSearchFilter *peopleFilter = [IMQuickSearchFilter filterWithSearchArray:self.People keys:@[@"firstName",@"lastName"]];
IMQuickSearchFilter *animalFilter = [IMQuickSearchFilter filterWithSearchArray:self.Animals keys:@[@"name"]];
```
So here I just created two filters, one for an array of people and one for an array of animals. The keys parameter corresponds directly to properties on the objects inside of each array. For instance, I have a Person object with a <code>firstName</code> and a <code>lastName</code> property, hence the two keys I added to the first filter.

Next you are going to initialize your IMQuickSearch master object with the two filters you created:

```objc
self.QuickSearch = [[IMQuickSearch alloc] initWithFilters:@[peopleFilter,animalFilter]];
```

After this, you are ready to search!

## Searching using IMQuickSearch

Searching through your arrays could not be easier. There is but one method call to make:

```objc
NSArray *filteredResults = [self.QuickSearch filteredObjectsWithValue:(id)someValue];
```

Filtering with NSStrings will probably be the most common use case, but you can filter by other class types as well. NSString filtering runs a comparison search over the property, resulting in fast filtering by strings. Any other value runs an equals search over the property matching value types exactly. For instance, if you are searching an NSNumber property with a value of <code>@4</code> then only properties that match will be returned, not a property whose value is <code>@40</code>.

**Extras**
* Filtering by <code>@""</code> returns ALL objects with NSString properties
* Filtering by <code>nil</code> returns ALL objects
* IMQuickSearch returns UNIQUE results.

**Manipulating Filters on the fly**

You can also add/remove IMQuickSearchFilter objects on the fly with this method:

```objc
IMQuickSearchFilter *someFilter;

// Add
[self.QuickSearch addFilter:someFilter];

// Remove
[self.QuickSearch removeFilter:someFilter];
```

## Demo Project

Run, play, and read through the demo project to understand how it all works and functions, including how to use it in your own app.

## Unit Tests

There are tests located inside of the Demo Project to run. In the future, a [Travis-CI](https://www.travis-ci.org) build will be used to guarantee all future commits and pull-requests don't break master.

## License

I think an MIT License will suit this project perfectly, though that is up to the overseers of Intermark to decide before this goes public.