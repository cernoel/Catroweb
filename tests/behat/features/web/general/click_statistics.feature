# Not compatible with the new ProjectList and must be reworked once the new design is finished: SHARE-371

@web @click_statistics
Feature: Creating click statistics by clicking on tags, extensions and recommended programs

  Background:
    Given there are users:
      | id | name      |
      | 1  | Catrobat  |
      | 2  | OtherUser |

    And there are extensions:
      | id | name         | prefix  |
      | 1  | Arduino      | ARDUINO |
      | 2  | Drone        | DRONE   |
      | 3  | Lego         | LEGO    |
      | 4  | Phiro        | PHIRO   |
      | 5  | Raspberry Pi | RASPI   |

    And there are tags:
      | id | en           | de           |
      | 1  | Game         | Spiel        |
      | 2  | Animation    | Animation    |
      | 3  | Story        | Geschichte   |
      | 4  | Music        | Musik        |
      | 5  | Art          | Kunst        |
      | 6  | Experimental | Experimental |

    And there are projects:
      | id | name    | description | owned by  | downloads | apk_downloads | views | upload time      | version | extensions | tags_id | remix_root |
      | 1  | Minions | p1          | Catrobat  | 3         | 2             | 12    | 01.01.2013 12:00 | 0.8.5   | Lego,Phiro | 1,2,3,4 | true       |
      | 2  | Galaxy  | p2          | OtherUser | 10        | 12            | 13    | 01.02.2013 12:00 | 0.8.5   | Lego,Drone | 1,2,3   | false      |
      | 3  | Alone   | p3          | Catrobat  | 5         | 55            | 2     | 01.03.2013 12:00 | 0.8.5   |            | 1,2     | true       |
      | 4  | Trolol  | p5          | Catrobat  | 5         | 1             | 1     | 01.03.2013 12:00 | 0.8.5   | Lego       | 5       | true       |
      | 5  | Nothing | p6          | Catrobat  | 5         | 1             | 1     | 01.03.2013 12:00 | 0.8.5   |            | 6       | true       |

    And there are forward remix relations:
      | ancestor_id | descendant_id | depth |
      | 1           | 1             | 0     |
      | 1           | 2             | 1     |
      | 2           | 2             | 0     |
      | 3           | 3             | 0     |
      | 4           | 4             | 0     |
      | 5           | 5             | 0     |

    And there are featured programs:
      | program_id | imagetype | active | flavor     | priority |
      | 2          | jpeg      | 1      | pocketcode | 0        |

  @javascript
  Scenario: Create one statistic entry from tags
    Given I am on "/app/project/1"
    And I wait for the page to be loaded
    When I press on the tag "Game"
    And I wait for AJAX to finish
    Then There should be one database entry with type is "tags" and "tag_id" is "1"
    And I should see "Your search returned 3 results"

  @javascript
  Scenario: Create one statistic entry from extensions
    Given I am on "/app/project/1"
    And I wait for the page to be loaded
    When I press on the extension "Lego"
    And I wait for AJAX to finish
    Then There should be one database entry with type is "extensions" and "extension_id" is "3"
    And I should see "Your search returned 3 results"
#
#  @javascript
#  Scenario: Create one statistic entry from programs
#    Given I am on "/app/project/1"
#    And I wait for the page to be loaded
#    When I click on the first recommended program
#    And I wait for AJAX to finish
#    Then There should be one database entry with type is "project" and "program_id" is "2"
#    And I should see "p2"
#
  @javascript
  Scenario: Create one statistic entry from featured programs on homepage
    Given I am on the homepage
    And I wait for the page to be loaded
    When I click on the first featured homepage program
    And I wait for AJAX to finish
    Then There should be one homepage click database entry with type is "featured" and program id is "2"
    And There should be no recommended click statistic database entry
    And I should see "Galaxy"
    And I should see "p2"

  @javascript
  Scenario: Create one statistic entry from newest programs on homepage
    Given I am on the homepage
    And I wait for the page to be loaded
    When I click on a "recent" homepage program having program id "2"
    And I wait for AJAX to finish
    Then There should be one homepage click database entry with type is "newest" and program id is "2"
    And There should be no recommended click statistic database entry
    And I should see "Galaxy"
    And I should see "p2"

  @javascript
  Scenario: Create one statistic entry from most downloaded programs on homepage
    Given I am on the homepage
    And I wait for the page to be loaded
    When I click on a "most_downloaded" homepage program having program id "3"
    And I wait for AJAX to finish
    Then There should be one homepage click database entry with type is "mostDownloaded" and program id is "3"
    And There should be no recommended click statistic database entry
    And I should see "Alone"
    And I should see "p3"

  @javascript
  Scenario: Create one statistic entry from most viewed programs on homepage
    Given I am on the homepage
    And I wait for the page to be loaded
    When I click on a "most_viewed" homepage program having program id "4"
    And I wait for AJAX to finish
    Then There should be one homepage click database entry with type is "mostViewed" and program id is "4"
    And There should be no recommended click statistic database entry
    And I should see "Trolol"
    And I should see "p5"

  @javascript
  Scenario: Create one statistic entry from random programs on homepage
    Given I am on the homepage
    And I wait for the page to be loaded
    When I click on a "random" homepage program having program id "2"
    And I wait for AJAX to finish
    Then There should be one homepage click database entry with type is "random" and program id is "2"
    And There should be no recommended click statistic database entry
    And I should see "Galaxy"
    And I should see "p2"

#  @javascript
#  Scenario: Create one statistic entry from recommended programs on homepage
#    Given there are projects:
#      | id | name    | description | owned by  | downloads | apk_downloads | views | upload time      | version |
#      | 21 | Minions | p1          | Catrobat  | 3         | 2             | 12    | 01.01.2013 12:00 | 0.8.5   |
#      | 22 | Galaxy  | p2          | OtherUser | 10        | 12            | 13    | 01.02.2013 12:00 | 0.8.5   |
#      | 23 | Alone   | p3          | Catrobat  | 5         | 55            | 2     | 01.03.2013 12:00 | 0.8.5   |
#
#    And there are project reactions:
#      | user      | project | type | created at       |
#      | Catrobat  | 21      | 1    | 01.01.2017 12:00 |
#      | Catrobat  | 22      | 2    | 01.01.2017 12:00 |
#      | OtherUser | 21      | 4    | 01.01.2017 12:00 |
#    Given I am on the homepage
#    And I wait for the page to be loaded
#    Then I should see a recommended homepage program having ID "21" and name "Minions"
#    When I click on the first recommended homepage program
#    And I wait for AJAX to finish
#    Then There should be one database entry with type is "rec_homepage" and "program_id" is "21"
#    And There should be one database entry with type is "rec_homepage" and "user_specific_recommendation" is "false"
#    And There should be no homepage click statistic database entry
#    And I should see "Minions"
#    And I should see "p1"
#
#  @javascript
#  Scenario: Create one statistic entry from recommended program that has been also downloaded by users that downloaded this program
#    Given there are program download statistics:
#      | id | program_id | downloaded_at       | ip             | country_code | country_name | user_agent | username  | referrer |
#      | 1  | 1          | 2017-02-09 16:01:00 | 88.116.169.222 | AT           | Austria      | okhttp     | OtherUser | Facebook |
#      | 2  | 3          | 2017-02-09 16:02:00 | 88.116.169.222 | AT           | Austria      | okhttp     | OtherUser | Facebook |
#
#    And I am on "/app/project/1"
#    And I wait for the page to be loaded
#    Then There should be recommended specific programs
#    When I click on the first recommended specific program
#    And I wait for AJAX to finish
#    Then There should be one database entry with type is "rec_specific_programs" and "program_id" is "3"
#    And I should see "Alone"
#    And I should see "p3"
#
#  @javascript
#  Scenario: No recommendable program that has been also downloaded by *other* users that downloaded this program
#    Given there are program download statistics:
#      | id | program_id | downloaded_at       | ip             | country_code | country_name | user_agent | username | referrer |
#      | 1  | 1          | 2017-02-09 16:01:00 | 88.116.169.222 | AT           | Austria      | okhttp     | Catrobat | Facebook |
#      | 2  | 3          | 2017-02-09 16:02:00 | 88.116.169.222 | AT           | Austria      | okhttp     | Catrobat | Facebook |
#
#    And I am on "/app/project/1"
#    And I wait for the page to be loaded
#    Then There should be no recommended specific programs
