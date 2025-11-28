import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  // Method to launch URLs with fallback
  Future<void> _launchURL(String url, {String? fallbackUrl}) async {
    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (fallbackUrl != null) {
        // If app-specific URL fails, try fallback (web URL)
        final Uri fallbackUri = Uri.parse(fallbackUrl);
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(fallbackUri);
        } else {
          throw 'Could not launch $url or $fallbackUrl';
        }
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
      // Fallback to web URL if both attempts fail
      if (fallbackUrl != null) {
        final Uri fallbackUri = Uri.parse(fallbackUrl);
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(fallbackUri);
        }
      }
    }
  }

  // LinkedIn with app preference
  void _launchLinkedIn() {
    // Try LinkedIn app first, then fallback to web
    const String appUrl = "linkedin://company/nagad-people-culture";
    const String webUrl =
        "https://www.linkedin.com/company/nagad-people-culture/";

    _launchURL(appUrl, fallbackUrl: webUrl);
  }

  // Facebook with app preference
  void _launchFacebook() {
    // Try Facebook app first, then fallback to web
    const String appUrl =
        "fb://page/?id=YOUR_FACEBOOK_PAGE_ID"; // You'll need to get your page ID
    const String webUrl =
        "https://www.facebook.com/share/17N9kou8jt/?mibextid=wwXIfr";

    // Alternative Facebook app URL format
    const String appUrlAlternative =
        "fb://facewebmodal/f?href=https://www.facebook.com/share/17N9kou8jt/";

    _launchURL(appUrlAlternative, fallbackUrl: webUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // LinkedIn
        IconButton(
          icon: FaIcon(FontAwesomeIcons.linkedin, color: Colors.red),
          iconSize: 36,
          onPressed: () {
            print("Redirecting to LinkedIn");
            _launchLinkedIn();
          },
        ),
        SizedBox(width: 20),
        // Facebook
        IconButton(
          icon: FaIcon(FontAwesomeIcons.squareFacebook, color: Colors.red),
          iconSize: 36,
          onPressed: () {
            print("Redirecting to Facebook");
            _launchFacebook();
          },
        ),
      ],
    );
  }
}
