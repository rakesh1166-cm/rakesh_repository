import 'package:flutter/material.dart';
import 'package:wizbrand_influencer/Screen/Influencer/becomeinfluencer.dart';
import 'package:wizbrand_influencer/Service/Influencer/influencer_service.dart';

class FormViewModel extends ChangeNotifier {
  final InfluencerAPI api;

  FormViewModel(this.api);

Future<void> submitForm(
  Map<String, String> formData,
  String? selectedCurrency,
  String formType,
  String? email,
  BuildContext context,
  int activeTabIndex,
) async {
  // Determine the API endpoint based on the form type
  String endpoint;

  if (formType == 'Add social site') {
    endpoint = 'addSocialSite';

    // Validate form data for social site
    for (String field in formData.keys) {
      // Normalize field to extract social site name
      String normalizedField = _extractSocialSiteName(field);

      // Skip validation for WordPress
      if (normalizedField == 'wordpress') {
        continue; // Skip to the next field
      }

      // Retrieve the URL for validation
      String? url = formData[field];
      print("url coming");
      print(url);
      print(normalizedField);

      // Field-specific validation
      if (normalizedField == 'facebook') {
        if (!_isValidFacebookUrl(url)) {
          _showValidationError(
            context,
            "Invalid Facebook URL",
            "Invalid Facebook URL: $url. Must be a valid Facebook profile or page link.",
          );
          return; // Stop execution
        }
      } else if (normalizedField == 'twitter') {
        if (!_isValidTwitterUrl(url)) {
          _showValidationError(
            context,
            "Invalid Twitter URL",
            "Invalid Twitter URL: $url. Must be a valid Twitter profile link.",
          );
          return;
        }
      } else if (normalizedField == 'youtube') {
        if (!_isValidYouTubeUrl(url)) {
          _showValidationError(
            context,
            "Invalid YouTube URL",
            "Invalid YouTube URL: $url. Must be a valid YouTube channel or video link.",
          );
          return;
        }
      } else if (normalizedField == 'tumblr') {
        if (!_isValidTumblrUrl(url)) {
          _showValidationError(
            context,
            "Invalid Tumblr URL",
            "Invalid Tumblr URL: $url. Must be a valid Tumblr link.",
          );
          return;
        }
      } else if (normalizedField == 'instagram') {
        if (!_isValidInstagramUrl(url)) {
          _showValidationError(
            context,
            "Invalid Instagram URL",
            "Invalid Instagram URL: $url. Must be a valid Instagram profile link.",
          );
          return;
        }
      } else if (normalizedField == 'quora') {
        if (!_isValidQuoraUrl(url)) {
          _showValidationError(
            context,
            "Invalid Quora URL",
            "Invalid Quora URL: $url. Must be a valid Quora profile link.",
          );
          return;
        }
      } else if (normalizedField == 'pinterest') {
        if (!_isValidPinterestUrl(url)) {
          _showValidationError(
            context,
            "Invalid Pinterest URL",
            "Invalid Pinterest URL: $url. Must be a valid Pinterest board or profile link.",
          );
          return;
        }
      } else if (normalizedField == 'reddit') {
        if (!_isValidRedditUrl(url)) {
          _showValidationError(
            context,
            "Invalid Reddit URL",
            "Invalid Reddit URL: $url. Must be a valid Reddit profile or subreddit link.",
          );
          return;
        }
      } else if (normalizedField == 'telegram') {
        if (!_isValidTelegramUrl(url)) {
          _showValidationError(
            context,
            "Invalid Telegram URL",
            "Invalid Telegram URL: $url. Must be a valid Telegram link.",
          );
          return;
        }
      } else if (normalizedField == 'linkedin') {
        if (!_isValidLinkedInUrl(url)) {
          _showValidationError(
            context,
            "Invalid LinkedIn URL",
            "Invalid LinkedIn URL: $url. Must be a valid LinkedIn profile link.",
          );
          return;
        }
      } else if (!_isValidSocialSite(normalizedField)) {
        _showValidationError(
          context,
          "Invalid Social Site",
          "Invalid social site name: $normalizedField",
        );
        return;
      }

      // Validate URL format for all fields except WordPress
      if (url != null && !_isValidUrl(url)) {
        _showValidationError(
          context,
          "Invalid URL Format",
          "Invalid URL format for $normalizedField: $url",
        );
        return;
      }
    }
  } else if (formType == 'Set Price') {
    endpoint = 'setPrice';

    if (selectedCurrency == null) {
      _showValidationError(
        context,
        "Currency Required",
        "Currency must be selected for setting price.",
      );
      return;
    }
  } else if (formType == 'Describe') {
    endpoint = 'describe';
  } else {
    _showValidationError(
      context,
      "Invalid Form Type",
      "Invalid form type: $formType.",
    );
    return;
  }

  print('Submitting $formType form with data: $formData and currency: $selectedCurrency');
  if (selectedCurrency != null) {
    formData['currency'] = selectedCurrency;
  }
  if (email != null) {
    formData['email'] = email;
  }

  // Call the API to submit the form data
  await api.submitFormData(formData, endpoint);

  notifyListeners();

  // Navigate back to TabScreen, passing the activeTabIndex
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TabScreen(initialTabIndex: activeTabIndex)),
  );
}

// Utility function to show validation error in a popup
void _showValidationError(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

// Helper function to extract the social site name from field labels
String _extractSocialSiteName(String field) {
  // Use regex or split logic to extract the social site name
  final RegExp regex = RegExp(r'Enter your (.*?) url', caseSensitive: false);
  final match = regex.firstMatch(field);
  if (match != null) {
    return match.group(1)!.toLowerCase(); // Return extracted social site name
  }
  return field.toLowerCase(); // Fallback to the original field
}

// Helper function to validate a Facebook URL
bool _isValidFacebookUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.contains("facebook.com") && _isValidUrl(url);
}

// Helper function to validate a Twitter URL
bool _isValidTwitterUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.contains("twitter.com") && _isValidUrl(url);
}

// Helper function to validate a YouTube URL
bool _isValidYouTubeUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.contains("youtube.com") && _isValidUrl(url);
}

// Helper function to validate a Tumblr URL
bool _isValidTumblrUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.contains("tumblr.com") && _isValidUrl(url);
}

// Helper function to validate an Instagram URL
bool _isValidInstagramUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.contains("instagram.com") && _isValidUrl(url);
}

// Helper function to validate a Quora URL
bool _isValidQuoraUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.contains("quora.com") && _isValidUrl(url);
}

// Helper function to validate a Pinterest URL
bool _isValidPinterestUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.contains("pinterest.com") && _isValidUrl(url);
}

// Helper function to validate a Reddit URL
bool _isValidRedditUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.contains("reddit.com") && _isValidUrl(url);
}

// Helper function to validate a Telegram URL
bool _isValidTelegramUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.contains("telegram.me") && _isValidUrl(url); // Telegram uses t.me short URL
}

// Helper function to validate a LinkedIn URL
bool _isValidLinkedInUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.contains("linkedin.com") && _isValidUrl(url);
}

// Helper function to validate if a field is a valid social site
bool _isValidSocialSite(String field) {
  const validSocialSites = [
    'facebook',
    'twitter',
    'youtube',
    'wordpress',
    'tumblr',
    'instagram',
    'quora',
    'pinterest',
    'reddit',
    'telegram',
    'linkedin',
  ];
  return validSocialSites.contains(field.toLowerCase());
}

// Helper function to validate a general URL format
bool _isValidUrl(String url) {
  final urlPattern =
      r'^(https?:\/\/)?(([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,})\/?.*$';
  final result = RegExp(urlPattern, caseSensitive: false).hasMatch(url);
  return result;
}

  // Helper function to validate if a field is a valid social site
 
}
