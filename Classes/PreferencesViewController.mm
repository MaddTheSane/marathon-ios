    //
//  PreferencesViewController.m
//  AlephOne
//
//  Created by Daniel Blezek on 10/13/10.
//  Copyright 2010 SDG Productions. All rights reserved.
//

#import "PreferencesViewController.h"
#import "GameViewController.h"
#import "BasicHUDViewController.h"
#import "AlephOneAppDelegate.h"
#import "Effects.h"
#include "preferences.h"
#include "Mixer.h"
#import "GameKit/GameKit.h"
#import "KeychainItemWrapper.h"

////#import "Tracking.h"
@implementation PreferencesViewController

@synthesize login, password;
@synthesize tapShoots;
@synthesize secondTapShoots;
@synthesize sfxVolume;
@synthesize musicVolume;
@synthesize hSensitivity;
@synthesize vSensitivity;
@synthesize musicLabel;
@synthesize crosshairs;
@synthesize onScreenTrigger;
@synthesize swipeToFire;
@synthesize gyroAiming;
@synthesize tiltTurning;
@synthesize brightness;
@synthesize autoCenter;
@synthesize filmsDisabled;
@synthesize vidmasterModeLabel, vidmasterMode;
@synthesize hiresTexturesLabel, hiresTextures;
@synthesize settingPrefsView;

- (IBAction)closePreferences:(id)sender {
  // Save the back to defaults
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  KeychainItemWrapper *keychain = [[[KeychainItemWrapper alloc] initWithIdentifier:@"metaserver" accessGroup:nil] autorelease];
  [keychain setObject:[login text] forKey:(id)kSecAttrAccount];
  [keychain setObject:[password text] forKey:(id)kSecValueData];
  
  [defaults setBool:[self.tapShoots isSelected] forKey:kTapShoots];
  if ( [self.tapShoots isSelected] != [defaults boolForKey:kTapShoots] ) {
    ////[Tracking trackEvent:@"settings" action:kTapShoots label:@"" value:[self.tapShoots isSelected]];

  }
  [defaults setBool:[self.crosshairs isSelected] forKey:kCrosshairs];
  if ( [self.crosshairs isSelected] != [defaults boolForKey:kCrosshairs] ) {
    ////[ Tracking trackEvent:@"settings" action:kCrosshairs label:@"" value:[self.crosshairs isSelected]];
  }
  
  [defaults setBool:[self.onScreenTrigger isSelected] forKey:kOnScreenTrigger];
  [defaults setBool:[self.swipeToFire isSelected] forKey:kswipeToFire];
  [defaults setBool:[self.gyroAiming isSelected] forKey:kGyroAiming];
  [defaults setBool:[self.tiltTurning isSelected] forKey:kTiltTurning];
  
  [defaults setBool:[self.secondTapShoots isSelected] forKey:kSecondTapShoots];
  if ( [self.secondTapShoots isSelected] != [defaults boolForKey:kSecondTapShoots] ) {
    ////[ Tracking trackEvent:@"settings" action:kSecondTapShoots label:@"" value:[self.secondTapShoots isSelected]];
  }
  [defaults setBool:[self.autoCenter isSelected] forKey:kAutocenter];
  if ( [self.autoCenter isSelected] != [defaults boolForKey:kAutocenter] ) {
    ////[ Tracking trackEvent:@"settings" action:kAutocenter label:@"" value:[self.autoCenter isSelected]];
  }
  [defaults setBool:[self.vidmasterMode isSelected] forKey:kUseVidmasterMode];
  if ( [self.vidmasterMode isSelected] != [defaults boolForKey:kUseVidmasterMode] ) {
    ////[ Tracking trackEvent:@"settings" action:kUseVidmasterMode label:@"" value:[self.vidmasterMode isSelected]];
  }
  [defaults setBool:[self.hiresTextures isSelected] forKey:kUseTTEP];
  if ( [self.hiresTextures isSelected] != [defaults boolForKey:kUseTTEP] ) {
    ////[ Tracking trackEvent:@"settings" action:kUseTTEP label:@"" value:[self.hiresTextures isSelected]];
  }
  
  [defaults setFloat:self.sfxVolume.value forKey:kSfxVolume];
  if ( self.sfxVolume.value != [defaults floatForKey:kSfxVolume] ) {
    ////[ Tracking trackEvent:@"settings" action:kSfxVolume label:@"" value: self.sfxVolume.value ];
  }
  [defaults setFloat:self.musicVolume.value forKey:kMusicVolume];
  if ( self.musicVolume.value != [defaults floatForKey:kMusicVolume] ) {
    ////[ Tracking trackEvent:@"settings" action:kMusicVolume label:@"" value: self.musicVolume.value ];
  }
  [defaults setFloat:self.hSensitivity.value forKey:kHSensitivity];
  if ( self.hSensitivity.value != [defaults floatForKey:kHSensitivity] ) {
    ////[ Tracking trackEvent:@"settings" action:kHSensitivity label:@"" value: self.hSensitivity.value ];
  }
  [defaults setFloat:self.brightness.value forKey:kGamma];
  if ( self.brightness.value != [defaults floatForKey:kGamma] ) {
    ////[ Tracking trackEvent:@"settings" action:kGamma label:@"" value: self.brightness.value ];
  }
  [defaults setFloat:self.hSensitivity.value forKey:kHSensitivity];
  if ( self.hSensitivity.value != [defaults floatForKey:kHSensitivity] ) {
    ////[ Tracking trackEvent:@"settings" action:kHSensitivity label:@"" value: self.hSensitivity.value ];
  }
  [defaults setFloat:self.vSensitivity.value forKey:kVSensitivity];
  if ( self.vSensitivity.value != [defaults floatForKey:kVSensitivity] ) {
    ////[ Tracking trackEvent:@"settings" action:kVSensitivity label:@"" value: self.vSensitivity.value ];
  }

  [defaults synchronize];
  [PreferencesViewController setAlephOnePreferences:YES checkPurchases:inMainMenu];
  [[GameViewController sharedInstance] updateReticule:-1];

  [[AlephOneAppDelegate sharedAppDelegate].game closePreferences:sender];
  
  // Crosshairs are set in the UI layer, not by the engine
  // Crosshairs_SetActive([defaults boolForKey:kCrosshairs]);
  Crosshairs_SetActive(NO);

}


- (void)setupUI:(BOOL)inMainMenuFlag {
  //self.settingPrefsView.hidden = YES; //DCW commented out after changinc appear/disappear animations.
  NSArray *sliders = [NSArray arrayWithObjects:self.hSensitivity,
                     self.vSensitivity,
                     self.brightness,
                     self.musicVolume,
                     self.sfxVolume, nil];

  for (UISlider *slider in sliders ) {
    [slider setThumbImage:[UIImage imageNamed:@"SliderTab"] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"SliderTab"] forState:UIControlStateSelected];
    [slider setThumbImage:[UIImage imageNamed:@"SliderTab"] forState:UIControlStateHighlighted];
    [slider setMaximumTrackImage:[UIImage imageNamed:@"SliderGreyTrack"]  forState:UIControlStateNormal];
    [slider setMinimumTrackImage:[UIImage imageNamed:@"SliderWhiteTrack"]forState:UIControlStateNormal];
  }
  
  
  KeychainItemWrapper *keychain = [[[KeychainItemWrapper alloc] initWithIdentifier:@"metaserver" accessGroup:nil] autorelease];
  [login setText:[keychain objectForKey:(id)kSecAttrAccount]];
  [password setText:[keychain objectForKey:(id)kSecValueData]];

  inMainMenu = inMainMenuFlag;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [self.tapShoots setSelected:[defaults boolForKey:kTapShoots]];
  [self.crosshairs setSelected:[defaults boolForKey:kCrosshairs]];
  
  [self.onScreenTrigger setSelected:[defaults boolForKey:kOnScreenTrigger]];
  [self.swipeToFire setSelected:[defaults boolForKey:kswipeToFire]];
  [self.gyroAiming setSelected:[defaults boolForKey:kGyroAiming]];
  [self.tiltTurning setSelected:[defaults boolForKey:kTiltTurning]];
  
  [self.autoCenter setSelected:[defaults boolForKey:kAutocenter]];
  [self.secondTapShoots setSelected:[defaults boolForKey:kSecondTapShoots]];
  self.sfxVolume.value = [defaults floatForKey:kSfxVolume];
  self.musicVolume.value = [defaults floatForKey:kMusicVolume];
  self.hSensitivity.value = [defaults floatForKey:kHSensitivity];
  self.vSensitivity.value = [defaults floatForKey:kVSensitivity];
  self.brightness.value = [defaults floatForKey:kGamma];
#if SCENARIO == 1
  self.musicLabel.hidden = NO;
  self.musicVolume.hidden = NO;
#endif
  self.hiresTexturesLabel.hidden = YES;
  self.hiresTextures.hidden = YES;
  [self.hiresTextures setSelected:[defaults boolForKey:kUseTTEP]];
  self.vidmasterModeLabel.hidden = YES;
  self.vidmasterMode.hidden = YES;
  [self.vidmasterMode setSelected:[defaults boolForKey:kUseVidmasterMode]]; 

  // MC Mode and HD mode
  self.hiresTextures.hidden = !inMainMenu || ![defaults boolForKey:kHaveTTEP];
  [self.hiresTextures setSelected:[defaults boolForKey:kUseTTEP]];
  self.vidmasterMode.hidden = ![defaults boolForKey:kHaveVidmasterMode];
  [self.vidmasterMode setSelected:[defaults boolForKey:kUseVidmasterMode]];

  
#if defined(A1DEBUG)
  self.hiresTexturesLabel.hidden = !inMainMenu || ![defaults boolForKey:kHaveTTEP];
  self.hiresTextures.hidden = !inMainMenu || ![defaults boolForKey:kHaveTTEP];
  [self.hiresTextures setSelected:[defaults boolForKey:kUseTTEP]];
  self.vidmasterModeLabel.hidden = ![defaults boolForKey:kHaveVidmasterMode];
  self.vidmasterMode.hidden = ![defaults boolForKey:kHaveVidmasterMode];
  [self.vidmasterMode setSelected:[defaults boolForKey:kUseVidmasterMode]];
  
#endif

  for ( UIView *view in self.view.subviews ) {
    if ( view.tag == 1000 ) {
#if defined(A1DEBUG)
      view.hidden = NO;
#else
      view.hidden = YES;
#endif
    }
  }
}


-(IBAction) toggleButton:(id)sender {
  if ( [sender isKindOfClass:[UIButton class]] ) {
    [sender setSelected:![sender isSelected]];
  }
}

- (IBAction)updatePreferences:(id)sender {
  [PreferencesViewController setAlephOnePreferences:YES checkPurchases:inMainMenu];
}

- (IBAction)resetAchievements:(id)sender {
  [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
    if ( error != nil ) {
      MLog(@"Failed to reset achievements: %@", error );
    } else {
      MLog(@"Achievements reset!" );
    }
  }];
}

- (IBAction)notifyOfChanges {
}

+ (void)setAlephOnePreferences:(BOOL)notifySoundManager checkPurchases:(BOOL)check{
  MLog ( @"Set preferences from device back to engine" );
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  sound_preferences->music = ceil ( (double)[defaults floatForKey:kMusicVolume] * (NUMBER_OF_SOUND_VOLUME_LEVELS-1) );
  sound_preferences->volume = ceil ( (double)[defaults floatForKey:kSfxVolume] * (NUMBER_OF_SOUND_VOLUME_LEVELS-1) );
  SoundManager::instance()->parameters.music = sound_preferences->music;
  SoundManager::instance()->parameters.volume = sound_preferences->volume;
  
  KeychainItemWrapper *keychain = [[[KeychainItemWrapper alloc] initWithIdentifier:@"metaserver" accessGroup:nil] autorelease];
  NSString *loginName=[keychain objectForKey:(id)kSecAttrAccount];
  NSString *pass=[keychain objectForKey:(id)kSecValueData];
  
  network_preferences->metaserver_login[0] = '\0';
  network_preferences->metaserver_password[0] = '\0';

  for (int i = 0; i < network_preferences_data::kMetaserverLoginLength && i < [loginName length]; ++i ) {
    network_preferences->metaserver_login[i] = [loginName characterAtIndex:i];
  }
  for (int i = 0; i < network_preferences_data::kMetaserverLoginLength && i < [pass length]; ++i ) {
    network_preferences->metaserver_password[i] = [pass characterAtIndex:i];
  }
  
  [[(BasicHUDViewController*)([[GameViewController sharedInstance] HUDViewController]) lookPadView] setHidden: ![defaults boolForKey:kOnScreenTrigger]];

  
  float sens;
  sens = [defaults floatForKey:kVSensitivity];
  if ( sens < 0.1 ) { sens = 0.1; }
  input_preferences->sens_vertical = _fixed ( sens * FIXED_ONE );
  sens = [defaults floatForKey:kHSensitivity];
  if ( sens < 0.1 ) { sens = 0.1; }
  input_preferences->sens_horizontal = _fixed ( sens * FIXED_ONE );
  
  // Auto center
  if ( [defaults boolForKey:kAutocenter] ) {
    input_preferences->modifiers &= ~_inputmod_dont_auto_recenter;
  } else {
    input_preferences->modifiers |= _inputmod_dont_auto_recenter;
  }
  // Never autocenter
  input_preferences->modifiers |= _inputmod_dont_auto_recenter;

  bool autorecenter = [defaults boolForKey:kAutorecenter];
  SET_FLAG(input_preferences->modifiers,_inputmod_dont_auto_recenter,!autorecenter);
  
  if ( [defaults boolForKey:kInvertY] ) {
    SET_FLAG(input_preferences->modifiers,_inputmod_invert_mouse, true);

    //  if (TEST_FLAG(input_preferences->modifiers, _inputmod_invert_mouse)) {
    //    input_preferences->modifiers &= ~_inputmod_invert_mouse;
  } else {
    //input_preferences->modifiers |= _inputmod_invert_mouse;
    SET_FLAG(input_preferences->modifiers,_inputmod_invert_mouse, false);
  }
    
#if defined(A1DEBUG)
  // Always autocenter, so we can do films
  // input_preferences->modifiers &= ~_inputmod_dont_auto_recenter;
#endif
  
  if ( notifySoundManager ) {
    // Sound ranges from 0-255, but is stored in 8 levels... go figure... 
    if ( Mixer::instance()->MusicPlaying() ) {
      Mixer::instance()->SetMusicChannelVolume ( ceil ( [defaults floatForKey:kMusicVolume] * MAXIMUM_SOUND_VOLUME ) );
    }
    Mixer::instance()->SetVolume ( ceil ( [defaults floatForKey:kSfxVolume] * MAXIMUM_SOUND_VOLUME ) );
  }
  
  // DJB This seems to cause flickering...
  // if ( check ) {
  //    [[AlephOneAppDelegate sharedAppDelegate].purchases performSelector:@selector(checkPurchases) withObject:nil afterDelay:0.2];
  //  }
}

- (void)appear {
	
	CAAnimation *group = [Effects appearAnimation];
  for ( UIView *v in self.view.subviews ) {
    [v.layer removeAllAnimations];
    [v.layer addAnimation:group forKey:nil];
  }
}

- (void)disappear:(UIView*)enclosingView {
	CAAnimation *group = [Effects disappearAnimation];
  for ( UIView *v in self.view.subviews ) {
    [v.layer removeAllAnimations];
    [v.layer addAnimation:group forKey:nil];
  }
}  

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
