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
So here I just created two filters, one for an array of people and one for an array of animals. The keys parameter corresponds directly to properties on the objects inside of each array. For instance, I have a Person object with a <code>firstName</code> and a <code>lastName</code> property, hence the two keys I added to the first filter. You don't have to add all of the properties to the keys array; just add the ones you want to filter by.

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

**Asyncronously Searching**

The main <code>filteredObjectsWithValue:</code> method searches the objects synchronously, on the main thread. However, if your data set is fairly large, you may want to move this work to a background thread so as not to disrupt or freeze the UI. You can do this with the following method:

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

## Benchmarks

After some basic tests with the same kind of <code>IMPerson</code>, <code>IMAnimal</code>, and <code>IMNumber</code> objects from the demo project, it appears that this grows linearlly with the growth of the data size. A 10x increase in objects results in about a 10x decrease in speed. Here's some results (each set is 1/3 People, 1/3 Animals, 1/3 Numbers):

```
3000 objects:
2014-01-06 09:33:49.930 IMQuickSearch[15514:70b] Start
2014-01-06 09:33:49.947 IMQuickSearch[15514:70b] Stop
.017s


30000 objects:
2014-01-06 09:48:29.178 IMQuickSearch[15589:70b] Start
2014-01-06 09:48:29.339 IMQuickSearch[15589:70b] Stop
.161s


300000 objects:
2014-01-06 09:49:21.058 IMQuickSearch[15604:70b] Start
2014-01-06 09:49:22.601 IMQuickSearch[15604:70b] Stop
1.543s


3000000 objects:
014-01-06 09:50:00.805 IMQuickSearch[15625:70b] Start
2014-01-06 09:50:16.580 IMQuickSearch[15625:70b] Stop
15.775s
```

## Demo Project

Run, play, and read through the demo project to understand how it all works and functions, including how to use it in your own app.

## Unit Tests

There are tests located inside of the Demo Project to run. In the future, a [Travis-CI](https://www.travis-ci.org) build will be used to guarantee all future commits and pull-requests don't break master.

## License

I think an MIT License will suit this project perfectly, though that is up to the overseers of Intermark to decide before this goes public.
