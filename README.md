![banner](https://raw.github.com/Intermark/IMQuickSearch/master/Images/banner.png)

## About

IMQuickSearch is a tool for quickly filtering multiple NSArrays that contain a variety of custom NSObject classes. It takes any value, and is not limited purely by an NSString. You can filter an NSObject by an NSNumber if you so choose. However, since its primary focus is for quickly filtering objects, when you filter by an NSString it performs a contains search - searching for "Bo" returns "Bob," "Probowl" and "Bojangles."

[![Build Status](https://travis-ci.org/Intermark/IMQuickSearch.png)](https://travis-ci.org/Intermark/IMQuickSearch)

![Demo](Images/Demo.gif)

## Installation

All of the important classes are located in the top-level directory `Classes`. The files you want to copy into your project are:

* `IMQuickSearch.{h,m}`
* `IMQuickSearchFilter.{h,m}`

Just `#import "IMQuickSearch.h"` in any class you want to use IMQuickSearch in.

**Cocoapods**

`pod 'IMQuickSearch'`

## Setting Up IMQuickSearch

To begin, you are going to want to have your NSArrays of NSObjects already populated and at your disposal. From here, you're going to create your IMQuickSearchFilter objects like so:

```objc
// Create People
IMPerson *p1 = ({
    IMPerson *p = [IMPerson new];
    p.firstName = @"Bob";
    p.LastName = @"Williams";
    p;
});

IMPerson *p2 = ({
    IMPerson *p = [IMPerson new];
    p.firstName = @"Alice";
    p.LastName = @"Johnson";
    p;
});

// Create Animals
IMAnimal *a1 = ({
    IMAnimal *a = [IMAnimal new];
    a.name = @"Aligator";
    a;
});

IMAnimal *a2 = ({
    IMAnimal *a = [IMAnimal new];
    a.name = @"Bison";
    a;
});

// Create Filters
IMQuickSearchFilter *peopleFilter = [IMQuickSearchFilter filterWithSearchArray:@[p1, p2] keys:@[@"firstName",@"lastName"]];
IMQuickSearchFilter *animalFilter = [IMQuickSearchFilter filterWithSearchArray:@[a1, a2] keys:@[@"name"]];
```
So here I just created two filters, one for an array of people and one for an array of animals. The keys parameter corresponds directly to properties on the objects inside of each array. For instance, I have a Person object with a `firstName` and a `lastName` property, hence the two keys I added to the first filter. You don't have to add all of the properties to the keys array; just add the ones you want to filter by.

Next you are going to initialize your IMQuickSearch master object with the two filters you created:

```objc
self.QuickSearch = [[IMQuickSearch alloc] initWithFilters:@[peopleFilter,animalFilter]];
```

After this, you are ready to search!

## Searching using IMQuickSearch

Searching through your arrays could not be easier. There is but one method call to make:

```objc
NSArray *filteredResults = [self.QuickSearch filteredObjectsWithValue:@"al"];

// filteredResults = @[p2,a1];
```

Here I filtered both arrays from the first example by the value `@"al"` which returned one combined array with the p2 and the a1 object. This is because `p2.firstName == @"Alice"` and `a1.name == @"Aligator"`. The other objects in both arrays don't match the value to be filtered by.

Filtering with NSStrings will probably be the most common use case, but you can filter by other class types as well. NSString filtering runs a comparison search over the property, resulting in fast filtering by strings. Any other value runs an equals search over the property matching value types exactly. For instance, if you are searching an NSNumber property with a value of `@4` then only properties that match will be returned, not a property whose value is `@40`.

**Asyncronously Searching**

The main `filteredObjectsWithValue:` method searches the objects synchronously, on the main thread. However, if your data set is fairly large, you may want to move this work to a background thread so as not to disrupt or freeze the UI. You can do this with the following method:

```objc
__block NSArray *results;
[self.QuickSearch asynchronouslyFilterObjectsWithValue:@"Hello" completion:^(NSArray *filteredResults)
{
    if (filteredResults) {
        results = filteredResults;
    }
}];
```

**Extras**
* Filtering by `@""` returns ALL objects with NSString properties
* Filtering by `nil` returns ALL objects
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

## What IMQuickSearch CAN'T Do

This library's great, but it does have some short-comings. Here they are:

**No recursive object graph searching.**

Basically this means that if you have a `Family` object that has an array of `Person` objects, and each `Person` object has a `firstName` property - you can't filter over a list of families for a person that has a firstName like what you're searching for. It doesn't go down the object graph looking for keys, only top-level object properties work. However arrays work for base checks. If you have an `NSArray` of `NSStrings` it will traverse the array seeing if one of the strings match to return `YES/NO` to.

**No parallel searching.**

Right now, each IMQuickSearchFilter is searched serially, and then a union set is made at the end. For each filter, the set of keys is done the exact same way. Theoretically it would be faster to do everything in parallel. Theoretically... Right now if you take a peek at the [`multithreaded` branch](https://github.com/Intermark/IMQuickSearch/tree/multithreaded) you can see my attempt at doing this. The quick benchmarks show that doing it serially actually takes only 72% of the time doing it concurrently does. Which is wacky. Since this is bad, it's not ready for production use, but we still think doing it this way has merit if done right. The problems may have to do with more and heavier instantiations done concurrently to manage this instead of the lightweight serial method.

**No saving the world.**

Unfortunately, this library cannot save the world if dire conditions arise. Though we are open to pull requests.

## Benchmarks

After some basic tests with the same kind of `IMPerson` and `IMAnimal` objects from the demo project, it appears that this grows linearlly with the growth of the data size. A 10x increase in objects results in about a 10x decrease in speed. Here's the quick and dirty results (each set is 1/2 People, 1/2 Animals):

```
iPhone 5C

200    objects - Avg. Runtime:     944661 ns    (0.0009 s)
2000   objects - Avg. Runtime:    6899177 ns    (0.0069 s)
20000  objects - Avg. Runtime:   79806582 ns    (0.08 s)
```

Now, let's benchmark against subsequent searches. This is using the same 2000 object data set (1/2 people, 1/2 animals). Because we're keeping the last search set around, and the idea that a subsequent search is contained by the last set, we don't have to use the master list of objects every time - only when the previous set won't contain the newest search set. Here's these benchmarks.

```
Value: @"a"
2014-04-28 08:38:23.575 IMQuickSearch[27953:60b] Start
2014-04-28 08:38:23.621 IMQuickSearch[27953:60b] Stop
0.046s

Value: @"al"
2014-04-28 08:38:25.497 IMQuickSearch[27953:60b] Start
2014-04-28 08:38:25.533 IMQuickSearch[27953:60b] Stop
0.036s

Value: @"ali"
2014-04-28 08:38:26.645 IMQuickSearch[27953:60b] Start
2014-04-28 08:38:26.655 IMQuickSearch[27953:60b] Stop
0.010s

Value: @"alig"
2014-04-28 08:40:39.194 IMQuickSearch[27953:60b] Start
2014-04-28 08:40:39.196 IMQuickSearch[27953:60b] Stop
0.002s
```

## Demo Project

Run, play, and read through the demo project to understand how it all works and functions, including how to use it in your own app.

## Unit Tests

There are tests located inside of the Demo Project to run. The library is also tested and run against a [Travis-CI](https://travis-ci.org/Intermark/IMQuickSearch) continuous integration server.

## License

This repository is licensed under the standard MIT License. You can read the license [here](https://github.com/Intermark/IMQuickSearch/blob/master/License).
