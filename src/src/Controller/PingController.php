<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;

class PingController extends AbstractController
{
    #[Route('/', name: 'app_ping')]
    public function index(): JsonResponse
    {
        return new JsonResponse(['_time' => time()]);
    }
}
