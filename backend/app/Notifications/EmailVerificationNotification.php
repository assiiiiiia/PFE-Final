<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Support\Facades\URL;
use Carbon\Carbon;
class EmailVerificationNotification extends Notification
{
    use Queueable;

    protected $prenom;

    public function __construct($prenom = null)
    {
        $this->prenom = $prenom;
    }

    public function via($notifiable)
    {
        return ['mail'];
    }

    public function toMail($notifiable)
    {
        $verificationUrl = $this->verificationUrl($notifiable);

        return (new MailMessage)
            ->subject('Confirmez votre adresse e-mail')
            ->greeting('Bonjour')
            ->line('Merci pour votre inscription. Veuillez cliquer sur le bouton ci-dessous pour vérifier votre adresse e-mail.')
            ->action('Vérifier mon e-mail', $verificationUrl)
            ->line('Si vous n’avez pas créé de compte, ignorez cet e-mail.')
            ->salutation('Cordialement, SAFQATIC');
    }

    protected function verificationUrl($notifiable)
    {
        return URL::temporarySignedRoute(
            'verification.verify',
            Carbon::now()->addMinutes(60),
            ['id' => $notifiable->getKey(), 'hash' => sha1($notifiable->getEmailForVerification())]
        );
    }
}
