import 'package:mh_clean_framework_sample/core/book/book_success_response.dart';
import 'package:mh_clean_framework_sample/features/details/models/book_details_model.dart';
import 'package:mh_clean_framework_sample/features/details/models/book_ratings_model.dart';
import 'package:mh_clean_framework_sample/features/home/models/book_model.dart';

const testBooks = [
  BookModel(
    key: 'OL45804W',
    title: 'Fantastic Mr. Fox',
    authors: [
      AuthorModel(key: 'OL34184A', name: 'Roald Dahl'),
    ],
    coverId: 10222599,
  ),
  BookModel(
    key: 'OL103123W',
    title: 'Fahrenheit 451',
    authors: [
      AuthorModel(key: 'OL24137A', name: 'Ray Bradbury'),
    ],
    coverId: 12817098,
  ),
];

const kTestBookDetails = BookDetailsModel(
  title: 'Fantastic Mr. Fox',
  subtitle: '',
  description:
      'Mr Fox steals food from the horrible farmers Boggis, Bunce and Bean - one fat, one short, one lean.',
);

const kTestBookRatings = BookRatingsModel(
  averageRating: 3.527,
  count: 543,
  starsToRatingCount: {
    RatingStar.one: 132,
    RatingStar.two: 12,
    RatingStar.three: 54,
    RatingStar.four: 128,
    RatingStar.five: 217
  },
);

const kTestBookCollectionSuccessResponse = BookSuccessResponse(
  data: {
    'query': '/trending/yearly',
    'works': [
      {
        'key': '/works/OL45804W',
        'title': 'Fantastic Mr. Fox',
        'author_key': ['OL34184A'],
        'author_name': ['Roald Dahl'],
        'cover_i': 10222599,
      },
      {
        'key': '/works/OL103123W',
        'title': 'Fahrenheit 451',
        'author_key': ['OL24137A'],
        'author_name': ['Ray Bradbury'],
        'cover_i': 12817098,
      }
    ],
  },
);

const kTestDetailsSuccessResponse = BookSuccessResponse(
  data: {
    'title': 'Fantastic Mr. Fox',
    'key': '/works/OL45804W',
    'authors': [
      {
        'author': {'key': '/authors/OL34184A'},
        'type': {'key': '/type/author_role'}
      }
    ],
  },
);

const kTestRatingsSuccessResponse = BookSuccessResponse(
  data: {
    'summary': {'average': 3.8, 'count': 85, 'sortable': 3.5259279970421757},
    'counts': {
      '1': 8,
      '2': 6,
      '3': 17,
      '4': 18,
      '5': 36,
    }
  },
);
